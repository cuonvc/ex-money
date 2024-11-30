import 'package:repository/src/models/expense_create_request.dart';

abstract class ExpenseRepository {
  Future<dynamic> getExpenseList(num? walletId);
  Future<dynamic> getExpenseEditResource(num? walletId);
  Future<dynamic> addExpense(ExpenseCreateRequest request);
}