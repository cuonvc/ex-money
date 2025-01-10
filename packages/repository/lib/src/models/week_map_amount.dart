class WeekMapAmount {
  int week;
  double amount;

  WeekMapAmount({
    required this.week,
    required this.amount
  });

  static Map<String, dynamic> toMap(WeekMapAmount data) {
    return {
      'week': data.week,
      'amount': data.amount
    };
  }

  static WeekMapAmount fromMap(Map<dynamic, dynamic> map) {
    return WeekMapAmount(
      week: map['week'],
      amount: map['amount']
    );
  }
}