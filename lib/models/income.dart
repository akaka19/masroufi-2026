class Income {
  double amount;
  int month;
  int year;

  Income({required this.amount, required this.month, required this.year});

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'month': month,
        'year': year,
      };

  factory Income.fromMap(Map<dynamic, dynamic> map) => Income(
        amount: (map['amount'] as num).toDouble(),
        month: map['month'] as int,
        year: map['year'] as int,
      );
}
