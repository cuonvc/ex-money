class ExpenseResponse {
  late String id;
  late String status;
  late String name;
  late String? description;
  late num amount;
  late String? currencyUnit;
  late String? type;
  late String walletId;
  late String walletName;
  late String userId;
  late String userName;
  late String categoryId;
  late String categoryName;
  late String createdAt;
  late String createdBy;
  late String? updatedAt;
  late String? updatedBy;

  ExpenseResponse({
    required this.id,
    required this.status,
    required this.name,
    required this.description,
    required this.amount,
    required this.currencyUnit,
    required this.type,
    required this.walletId,
    required this.walletName,
    required this.userId,
    required this.userName,
    required this.categoryId,
    required this.categoryName,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy
  });

  static fromMap(Map<String, dynamic> data) {
    return ExpenseResponse(
        id: data['id'],
        status: data['status'],
        name: data['name'],
        description: data['description'],
        amount: data['amount'],
        currencyUnit: data['currencyUnit'],
        type: data['type'],
        walletId: data['walletId'],
        walletName: data['walletName'],
        userId: data['userId'],
        userName: data['userName'],
        categoryId: data['categoryId'],
        categoryName: data['categoryName'],
        createdAt: data['createdAt'],
        createdBy: data['createdBy'],
        updatedAt: data['updatedAt'],
        updatedBy: data['updatedBy']
    );
  }
}