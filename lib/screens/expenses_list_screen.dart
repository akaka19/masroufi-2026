import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../utils/categories.dart';

class ExpensesListScreen extends StatelessWidget {
  const ExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لائحة المصاريف'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('expenses').listenable(),
        builder: (context, box, __) {
          final entries = box.toMap().entries.toList();
          final expenses = entries.map((e) {
            final data = Expense.fromMap(e.value as Map);
            return MapEntry(e.key, data);
          }).toList()
            ..sort((a, b) => b.value.date.compareTo(a.value.date));

          if (expenses.isEmpty) {
            return const Center(child: Text('ما كاين حتى مصروف'));
          }

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, i) {
              final key = expenses[i].key;
              final e = expenses[i].value;
              final cat = categories.firstWhere(
                (c) => c.name == e.category,
                orElse: () => categories.last,
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cat.color.withOpacity(0.2),
                    child: Icon(cat.icon, color: cat.color),
                  ),
                  title: Text(e.name),
                  subtitle: Text('${e.category} • ${e.date.toString().substring(0, 10)}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${e.amount.toStringAsFixed(2)} د.م',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        e.isPaid ? 'مخلص' : 'ما مخلصاش',
                        style: TextStyle(
                          color: e.isPaid ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('حذف؟'),
                        content: Text('واش بغيتي تحذف "${e.name}"؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('لا'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('واه'),
                          ),
                        ],
                      ),
                    );
                    if (result == true) await box.delete(key);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
