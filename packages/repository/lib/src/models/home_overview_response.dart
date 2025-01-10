import 'package:repository/repository.dart';
import 'package:repository/src/models/week_map_amount.dart';

class HomeOverviewResponse {
  num currentMonth;
  UserResponse user;
  num totalExpenseAmount = 0; //just for you
  num moreThanLastMonth = 0;
  List<ExpenseResponse> ownerExpenses = [];
  List<WeekMapAmount> weeks;

  HomeOverviewResponse({
    required this.currentMonth,
    required this.user,
    required this.totalExpenseAmount,
    required this.moreThanLastMonth,
    required this.ownerExpenses,
    required this.weeks
  });

  static HomeOverviewResponse fromMap(Map<String, dynamic> data) {
    List expenses = data['ownerExpenses'];
    List<ExpenseResponse> responseList = expenses
        .map((e) => ExpenseResponse.fromMap(e))
        .toList();

    UserResponse user = UserResponse.fromMap(data['user']);

    List rawWeeks = data['weekMapAmount'];
    List<WeekMapAmount> weeks = rawWeeks.map((w) => WeekMapAmount.fromMap(w)).toList();
    
    return HomeOverviewResponse(
        currentMonth: data['currentMonth'],
        user: user,
        totalExpenseAmount: data['totalExpenseAmount'],
        moreThanLastMonth: data['moreThanLastMonth'],
        ownerExpenses: responseList,
        weeks: weeks
    );
  }

  static Map<String, dynamic> toMap(HomeOverviewResponse data) {

    List<ExpenseResponse> list = data.ownerExpenses;
    List<Map<String, dynamic>> listMap = list.map((ex) => ExpenseResponse.toMap(ex)).toList();

    return {
      'currentMonth': data.currentMonth,
      'user': UserResponse.toMap(data.user),
      'totalExpenseAmount': data.totalExpenseAmount,
      'moreThanLastMonth': data.moreThanLastMonth,
      'ownerExpenses': listMap,
      'weekMapAmount': data.weeks.map((w) => WeekMapAmount.toMap(w)).toList()
    };
  }
}