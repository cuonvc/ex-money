part of 'get_expense_bloc.dart';

sealed class GetExpenseEvent extends Equatable {
  const GetExpenseEvent();

  @override
  List<Object?> get props => [];
}

class GetExpenseEv extends GetExpenseEvent {
  late final ExpenseResponse expenseResponse;

  @override
  List<Object?> get props => [expenseResponse];
}

