import 'package:repository/src/models/expense_create_request.dart';

abstract class ExpenseRepository {
  Future<dynamic> getExpenseList(num? walletId, String? keyword, num? categoryId, num? createdById);
  Future<dynamic> getExpenseEditResource(num? walletId);
  Future<dynamic> addExpense(ExpenseCreateRequest request);
  Future<dynamic> getExpenseFilterResource(num? walletId);
}