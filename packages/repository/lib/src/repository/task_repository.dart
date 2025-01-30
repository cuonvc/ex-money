import 'package:repository/repository.dart';

abstract class TaskRepository {
  Future<dynamic> createExpenseScheduler(ExpenseSchedulerRequest request);
}