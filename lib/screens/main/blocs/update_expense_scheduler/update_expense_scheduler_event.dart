part of 'update_expense_scheduler_bloc.dart';

sealed class UpdateExpenseSchedulerEvent extends Equatable {
  const UpdateExpenseSchedulerEvent();

  @override
  List<Object> get props => [];
}


class UpdateExpenseSchedulerEv extends UpdateExpenseSchedulerEvent {
  final num id;
  final ExpenseSchedulerRequest request;

  const UpdateExpenseSchedulerEv({
    required this.id,
    required this.request
  });
}