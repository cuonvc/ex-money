import 'package:repository/repository.dart';

abstract class ExpenseRepository {
  Future<dynamic> getExpenseList(num? walletId, String? keyword, num? categoryId, num? createdById);
  Future<dynamic> getExpenseEditResource(num? walletId);
  Future<dynamic> addExpense(ExpenseCreateRequest request);
  Future<dynamic> updateExpense(num id, ExpenseUpdateRequest request);
  Future<dynamic> getExpenseFilterResource(num? walletId);
}