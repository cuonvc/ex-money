class ExpenseResponse {
  late num id;
  late String status;
  late String? description;
  late num amount;
  late String? currencyUnit;
  late String entryDate;
  late String entryType;
  late String? type;
  late num walletId;
  late String walletName;
  late num userId;
  late String userName;
  late num categoryId;
  late String categoryName;
  late String createdAt;
  late String createdBy;
  late String? updatedAt;
  late String? updatedBy;

  ExpenseResponse({
    required this.id,
    required this.status,
    required this.description,
    required this.amount,
    required this.currencyUnit,
    required this.entryDate,
    required this.entryType,
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

  static ExpenseResponse fromMap(Map<String, dynamic> data) {
    return ExpenseResponse(
        id: data['id'],
        status: data['status'],
        description: data['description'],
        amount: data['amount'],
        currencyUnit: data['currencyUnit'],
        entryDate: data['entryDate'],
        entryType: data['entryType'],
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