import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import '../models/income.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';
import 'expenses_list_screen.dart';
import 'alerts_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  List<Expense> _monthExpenses() {
    final box = Hive.box('expenses');
    return box.values.map((v) => Expense.fromMap(v)).where((e) {
      return e.date.month == month && e.date.year == year;
    }).toList();
  }

  double _monthIncome() {
    final box = Hive.box('incomes');
    final incomes = box.values.map((v) => Income.fromMap(v)).where(
          (i) => i.month == month && i.year == year,
        );
    return incomes.fold(0.0, (s, i) => s + i.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الميزانية الشهرية'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('expenses').listenable(),
        builder: (context, _, __) {
          final expenses = _monthExpenses();
          final totalExp = expenses.fold(0.0, (s, e) => s + e.amount);
          final income = _monthIncome();
          final remaining = income - totalExp;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _card('الشهر', '$month/$year', Colors.blueGrey),
                _card('الدخل', '${income.toStringAsFixed(2)} د.م', Colors.green),
                _card('المصاريف', '${totalExp.toStringAsFixed(2)} د.م', Colors.red),
                _card(
                  'الباقي',
                  '${remaining.toStringAsFixed(2)} د.م',
                  remaining >= 0 ? Colors.teal : Colors.orange,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddIncomeScreen()),
                          );
                          setState(() {});
                        },
                        icon: const Icon(Icons.attach_money),
                        label: const Text('الدخل'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                          );
                          setState(() {});
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('مصروف'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _menu('لائحة المصاريف', Icons.list, const ExpensesListScreen()),
                _menu('التنبيهات', Icons.notifications, const AlertsScreen()),
                _menu('الإحصائيات', Icons.bar_chart, const StatsScreen()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(String title, String value, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _menu(String label, IconData icon, Widget screen) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      ),
    );
  }
}
