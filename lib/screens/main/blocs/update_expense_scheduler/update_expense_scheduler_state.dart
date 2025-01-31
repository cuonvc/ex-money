part of 'update_expense_scheduler_bloc.dart';

sealed class UpdateExpenseSchedulerState extends Equatable {
  const UpdateExpenseSchedulerState();

  @override
  List<Object> get props => [];
}

final class UpdateExpenseSchedulerInitial extends UpdateExpenseSchedulerState {}
final class UpdateExpenseSchedulerLoading extends UpdateExpenseSchedulerState {}
final class UpdateExpenseSchedulerFailure extends UpdateExpenseSchedulerState {
  final String message;

  const UpdateExpenseSchedulerFailure({
    required this.message
  });
}

final class UpdateExpenseSchedulerSuccess extends UpdateExpenseSchedulerState {
  final String message;
  final ExpenseSchedulerResponse response;

  const UpdateExpenseSchedulerSuccess({
    required this.message,
    required this.response
  });
}
