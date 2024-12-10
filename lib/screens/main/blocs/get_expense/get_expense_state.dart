part of 'get_expense_bloc.dart';

sealed class GetExpenseState extends Equatable {
  const GetExpenseState();
  List<Object?> get props => [];
}

final class GetExpenseInitial extends GetExpenseState {}
final class GetExpenseLoading extends GetExpenseState {}
final class GetExpenseFailure extends GetExpenseState {
  final String message;

  const GetExpenseFailure(this.message);
}
final class GetExpenseSuccess extends GetExpenseState {
  final List<ExpenseResponse> data;

  const GetExpenseSuccess(this.data);
}
