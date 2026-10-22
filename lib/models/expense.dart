class Expense {
  String name;
  double amount;
  String category;
  DateTime date;
  bool isPaid;

  Expense({
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'isPaid': isPaid,
      };

  factory Expense.fromMap(Map<dynamic, dynamic> map) => Expense(
        name: map['name'] as String,
        amount: (map['amount'] as num).toDouble(),
        category: map['category'] as String,
        date: DateTime.parse(map['date'] as String),
        isPaid: map['isPaid'] as bool? ?? false,
      );
}
