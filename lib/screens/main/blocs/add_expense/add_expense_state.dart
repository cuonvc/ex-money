part of 'add_expense_bloc.dart';

sealed class AddExpenseState extends Equatable {
  const AddExpenseState();

  @override
  List<Object> get props => [];
}

final class AddExpenseInitial extends AddExpenseState {}
final class AddExpenseLoading extends AddExpenseState {}
final class AddExpenseFailure extends AddExpenseState {
  final int statusCode;
  final String message;

  const AddExpenseFailure({required this.statusCode, required this.message});
}

final class AddExpenseSuccess extends AddExpenseState {
  final ExpenseResponse expense;

  const AddExpenseSuccess({required this.expense});
}