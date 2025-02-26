part of 'create_expense_scheduler_bloc.dart';

sealed class CreateExpenseSchedulerState extends Equatable {
  const CreateExpenseSchedulerState();

  @override
  List<Object> get props => [];
}

final class CreateExpenseSchedulerInitial extends CreateExpenseSchedulerState {}
final class CreateExpenseSchedulerLoading extends CreateExpenseSchedulerState {}
final class CreateExpenseSchedulerFailure extends CreateExpenseSchedulerState {
  final int statusCode;
  final String message;

  const CreateExpenseSchedulerFailure({
    required this.statusCode,
    required this.message
  });
}

final class CreateExpenseSchedulerSuccess extends CreateExpenseSchedulerState {
  final ExpenseSchedulerResponse response;

  const CreateExpenseSchedulerSuccess({
    required this.response
  });
}
