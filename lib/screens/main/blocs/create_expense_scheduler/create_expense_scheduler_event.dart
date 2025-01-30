part of 'create_expense_scheduler_bloc.dart';

sealed class CreateExpenseSchedulerEvent extends Equatable {
  const CreateExpenseSchedulerEvent();

  @override
  List<Object> get props => [];
}

class CreateExpenseSchedulerEv extends CreateExpenseSchedulerEvent {
  final ExpenseSchedulerRequest request;

  const CreateExpenseSchedulerEv({
    required this.request
  });
}