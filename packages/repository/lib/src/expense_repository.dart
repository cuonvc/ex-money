abstract class ExpenseRepository {
  Future<dynamic> getExpenseList(String? walletId);
  Future<dynamic> getExpenseEditResource(String? walletId);
}