import 'package:repository/src/models/expense_create_request.dart';

abstract class ExpenseRepository {
  Future<dynamic> getExpenseList(String? walletId);
  Future<dynamic> getExpenseEditResource(String? walletId);
  Future<dynamic> addExpense(ExpenseCreateRequest request);
}