class ExpenseConfirmResponse {
  late String description;
  late num? amount;
  late num? walletId;
  late String? walletName;
  late num? categoryId;
  late String? categoryName;

  ExpenseConfirmResponse({
    required this.description,
    required this.amount,
    required this.walletId,
    required this.walletName,
    required this.categoryId,
    required this.categoryName
  });

  static Map<String, dynamic> toMap(ExpenseConfirmResponse data) {
    return {
      'description': data.description,
      'amount': data.amount,
      'walletId': data.walletId,
      'walletName': data.walletName,
      'categoryId': data.categoryId,
      'categoryName': data.categoryName,
    };
  }

  static ExpenseConfirmResponse fromMap(Map<String, dynamic> map) {
    return ExpenseConfirmResponse(
      description: map['description'],
      amount: map['amount'],
      walletId: map['walletId'],
      walletName: map['walletName'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
    );
  }
}