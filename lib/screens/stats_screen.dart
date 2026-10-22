import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../utils/categories.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإحصائيات'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('expenses').listenable(),
        builder: (context, box, __) {
          final all = box.values.map((v) => Expense.fromMap(v as Map)).toList();

          if (all.isEmpty) {
            return const Center(child: Text('ما كاين حتى معطيات'));
          }

          final Map<String, double> byCategory = {};
          for (final e in all) {
            byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
          }

          final sorted = byCategory.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          final total = sorted.fold(0.0, (s, e) => s + e.value);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('المصاريف حسب الفئة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...sorted.map((entry) {
                final cat = categories.firstWhere(
                  (c) => c.name == entry.key,
                  orElse: () => categories.last,
                );
                final percent = total == 0 ? 0.0 : entry.value / total;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cat.color.withOpacity(0.2),
                      child: Icon(cat.icon, color: cat.color),
                    ),
                    title: Text(entry.key),
                    subtitle: LinearProgressIndicator(
                      value: percent,
                      color: cat.color,
                      backgroundColor: Colors.grey.shade200,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${entry.value.toStringAsFixed(2)} د.م',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('${(percent * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('المجموع',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${total.toStringAsFixed(2)} د.م',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.teal)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
