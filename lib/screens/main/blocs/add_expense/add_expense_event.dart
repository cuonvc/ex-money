part of 'add_expense_bloc.dart';

sealed class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object?> get props  => [];
}

class AddExpenseEv extends AddExpenseEvent {
  final ExpenseCreateRequest request;

  const AddExpenseEv(this.request);

  @override
  List<Object?> get props => [request];
}
