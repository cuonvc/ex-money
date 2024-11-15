import 'package:repository/src/utils/constant.dart';

class ExpenseCreateRequest {
  late String description;
  late num amount;
  late String entryType; //EXPENSE - INCOME
  late String entryDate;
  late String type;
  late String categoryId;
  late String walletId;

  ExpenseCreateRequest({
    required this.description,
    required this.amount,
    required this.entryType,
    required this.entryDate,
    required this.type,
    required this.categoryId,
    required this.walletId,
  });

  static empty() {
    return ExpenseCreateRequest(
      description: '',
      amount: 0,
      entryType: ExpenseConstant.entry_type_expense,
      entryDate: '',
      type: ExpenseConstant.type_manual,
      categoryId: '',
      walletId: '',
    );
  }

  static Map<String, dynamic> toMap(ExpenseCreateRequest request) {
    return {
      'description': request.description,
      'amount': request.amount,
      'entryType': request.entryType,
      'entryDate': request.entryDate,
      'type': request.type,
      'categoryId': request.categoryId,
      'walletId': request.walletId,
    };
  }
}