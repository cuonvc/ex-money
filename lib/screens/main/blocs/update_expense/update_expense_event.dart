part of 'update_expense_bloc.dart';

sealed class UpdateExpenseEvent extends Equatable {
  const UpdateExpenseEvent();

  @override
  List<Object> get props => [];
}

class UpdateExpenseEv extends UpdateExpenseEvent {
  final num id;
  final ExpenseUpdateRequest request;

  const UpdateExpenseEv({
    required this.id,
    required this.request
  });
}
