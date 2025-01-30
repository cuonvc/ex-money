import 'package:repository/repository.dart';

class ExpenseSchedulerRequest {
  late ExpenseCreateRequest expense;
  late String timeInterval;
  late int timeValue;

  ExpenseSchedulerRequest({
    required this.expense,
    required this.timeInterval,
    required this.timeValue
  });

  static toMap(ExpenseSchedulerRequest request) {
    Map<String, dynamic> expense = ExpenseCreateRequest.toMap(request.expense);

    return {
      'expense': expense,
      'timeInterval': request.timeInterval,
      'timeValue': request.timeValue
    };
  }
}