import 'package:repository/repository.dart';
import 'package:repository/src/models/notification_response.dart';
import 'package:repository/src/models/week_map_amount.dart';

class HomeOverviewResponse {
  num currentMonth;
  UserResponse user;
  List<NotificationResponse> notifications;
  num totalExpenseAmount = 0; //just for you
  num moreThanLastMonth = 0;
  List<ExpenseResponse> ownerExpenses = [];
  List<WeekMapAmount> weeks;

  HomeOverviewResponse({
    required this.currentMonth,
    required this.user,
    required this.notifications,
    required this.totalExpenseAmount,
    required this.moreThanLastMonth,
    required this.ownerExpenses,
    required this.weeks
  });

  static HomeOverviewResponse fromMap(Map<String, dynamic> data) {
    List expenses = data['ownerExpenses'];
    List notifications = data['notifications'];
    List<ExpenseResponse> expenseList = expenses
        .map((e) => ExpenseResponse.fromMap(e))
        .toList();

    List<NotificationResponse> notificationList = notifications
        .map((noti) => NotificationResponse.fromMap(noti))
        .toList();

    UserResponse user = UserResponse.fromMap(data['user']);

    List rawWeeks = data['weekMapAmount'];
    List<WeekMapAmount> weeks = rawWeeks.map((w) => WeekMapAmount.fromMap(w)).toList();
    
    return HomeOverviewResponse(
        currentMonth: data['currentMonth'],
        user: user,
        notifications: notificationList,
        totalExpenseAmount: data['totalExpenseAmount'],
        moreThanLastMonth: data['moreThanLastMonth'],
        ownerExpenses: expenseList,
        weeks: weeks
    );
  }

  static Map<String, dynamic> toMap(HomeOverviewResponse data) {

    List<ExpenseResponse> list = data.ownerExpenses;
    List<Map<String, dynamic>> expenseListMap = list.map((ex) => ExpenseResponse.toMap(ex)).toList();

    List<NotificationResponse> notiList = data.notifications;
    List<Map<String, dynamic>> notiListMap = notiList.map((noti) => NotificationResponse.toMap(noti)).toList();

    return {
      'currentMonth': data.currentMonth,
      'user': UserResponse.toMap(data.user),
      'notifications': notiListMap,
      'totalExpenseAmount': data.totalExpenseAmount,
      'moreThanLastMonth': data.moreThanLastMonth,
      'ownerExpenses': expenseListMap,
      'weekMapAmount': data.weeks.map((w) => WeekMapAmount.toMap(w)).toList()
    };
  }
}