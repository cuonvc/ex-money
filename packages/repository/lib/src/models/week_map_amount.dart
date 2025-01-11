class WeekMapAmount {
  num week;
  num amount;

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
    num w = map['week'];
    num a = map['amount'];
    return WeekMapAmount(
      week: w,
      amount: a
    );
  }
}