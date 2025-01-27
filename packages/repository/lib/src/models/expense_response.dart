import 'dart:developer';

class ExpenseResponse {
  late num id;
  late String status;
  late String? description;
  late num amount;
  late String categoryIconImage;
  late String? currencyUnit;
  late String entryDate;
  late String entryType;
  late String? type;
  late num walletId;
  late String walletName;
  late num categoryId;
  late String categoryName;
  late num? parentCategoryId; //optional
  late String? parentCategoryName; //optional
  late String createdAt;
  late String createdBy;
  late String? updatedAt;
  late String? updatedBy;

  ExpenseResponse({
    required this.id,
    required this.status,
    required this.description,
    required this.amount,
    required this.categoryIconImage,
    required this.currencyUnit,
    required this.entryDate,
    required this.entryType,
    required this.type,
    required this.walletId,
    required this.walletName,
    required this.categoryId,
    required this.categoryName,
    required this.parentCategoryId,
    required this.parentCategoryName,
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
        categoryIconImage: data['categoryIconImage'],
        currencyUnit: data['currencyUnit'],
        entryDate: data['entryDate'],
        entryType: data['entryType'],
        type: data['type'],
        walletId: data['walletId'],
        walletName: data['walletName'],
        categoryId: data['categoryId'],
        categoryName: data['categoryName'],
        parentCategoryId: data['parentCategoryId'],
        parentCategoryName: data['parentCategoryName'],
        createdAt: data['createdAt'],
        createdBy: data['createdBy'],
        updatedAt: data['updatedAt'],
        updatedBy: data['updatedBy']
    );
  }

  static Map<String, dynamic> toMap(ExpenseResponse data) {
    return {
      'id': data.id,
      'status': data.status,
      'description': data.description,
      'amount': data.amount,
      'categoryIconImage': data.categoryIconImage,
      'currencyUnit': data.currencyUnit,
      'entryDate': data.entryDate,
      'entryType': data.entryType,
      'type': data.type,
      'walletId': data.walletId,
      'walletName': data.walletName,
      'categoryId': data.categoryId,
      'categoryName': data.categoryName,
      'parentCategoryId': data.parentCategoryId,
      'parentCategoryName': data.parentCategoryName,
      'createdAt': data.createdAt,
      'createdBy': data.createdBy,
      'updatedAt': data.updatedAt,
      'updatedBy': data.updatedBy
    };
  }
}