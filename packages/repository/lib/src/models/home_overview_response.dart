import 'package:repository/repository.dart';

class HomeOverviewResponse {
  num currentMonth;
  UserResponse user;
  num totalExpenseAmount = 0; //just for you
  num moreThanLastMonth = 0;
  List<ExpenseResponse> ownerExpenses = [];

  HomeOverviewResponse({
    required this.currentMonth,
    required this.user,
    required this.totalExpenseAmount,
    required this.moreThanLastMonth,
    required this.ownerExpenses
  });

  static HomeOverviewResponse fromMap(Map<String, dynamic> data) {
    List expenses = data['ownerExpenses'];
    List<ExpenseResponse> responseList = expenses
        .map((e) => ExpenseResponse.fromMap(e))
        .toList();

    UserResponse user = UserResponse.fromMap(data['user']);

    return HomeOverviewResponse(
      currentMonth: data['currentMonth'],
      user: user,
      totalExpenseAmount: data['totalExpenseAmount'],
      moreThanLastMonth: data['moreThanLastMonth'],
      ownerExpenses: responseList
    );
  }
}