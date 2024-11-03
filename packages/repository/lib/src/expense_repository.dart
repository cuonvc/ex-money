abstract class ExpenseRepository {
  Future<dynamic> getExpenseList(String? walletId);
}