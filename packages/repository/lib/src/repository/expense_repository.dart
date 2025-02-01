import 'package:repository/repository.dart';

abstract class ExpenseRepository {
  Future<dynamic> getExpenseList(num? walletId, String? keyword, num? categoryId, num? createdById, String? startDate, String? endDate);
  Future<dynamic> getExpenseEditResource(num? walletId);
  Future<dynamic> addExpense(ExpenseCreateRequest request);
  Future<dynamic> updateExpense(num id, ExpenseUpdateRequest request);
  Future<dynamic> deleteExpense(num id);
  Future<dynamic> getExpenseFilterResource(num? walletId);
  Future<dynamic> getConfirmExpenseFromSpeech(String text);
}