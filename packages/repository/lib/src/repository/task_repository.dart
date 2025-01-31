import 'package:repository/repository.dart';

abstract class TaskRepository {
  Future<dynamic> createExpenseScheduler(ExpenseSchedulerRequest request);
  Future<dynamic> updateExpenseScheduler(num id, ExpenseSchedulerRequest request);
}