import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التنبيهات'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('expenses').listenable(),
        builder: (context, box, __) {
          final entries = box.toMap().entries.toList();
          final unpaid = entries
              .map((e) => MapEntry(e.key, Expense.fromMap(e.value as Map)))
              .where((e) => !e.value.isPaid)
              .toList()
            ..sort((a, b) => a.value.date.compareTo(b.value.date));

          if (unpaid.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  '✅ ما كاين حتى شي حاجة ما مخلصاش',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final now = DateTime.now();

          return ListView.builder(
            itemCount: unpaid.length,
            itemBuilder: (context, i) {
              final key = unpaid[i].key;
              final e = unpaid[i].value;
              final overdue = e.date.isBefore(now);

              return Card(
                color: overdue ? Colors.red.shade50 : Colors.orange.shade50,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    overdue ? Icons.warning : Icons.info,
                    color: overdue ? Colors.red : Colors.orange,
                  ),
                  title: Text(e.name),
                  subtitle: Text(
                    overdue
                        ? 'فات التاريخ! (${e.date.toString().substring(0, 10)})'
                        : 'ما مخلصاش • ${e.date.toString().substring(0, 10)}',
                  ),
                  trailing: Text(
                    '${e.amount.toStringAsFixed(2)} د.م',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    final data = Map<String, dynamic>.from(e.toMap());
                    data['isPaid'] = true;
                    await box.put(key, data);
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
