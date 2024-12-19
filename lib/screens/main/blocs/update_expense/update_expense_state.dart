part of 'update_expense_bloc.dart';

sealed class UpdateExpenseState extends Equatable {
  const UpdateExpenseState();

  @override
  List<Object> get props => [];
}

final class UpdateExpenseInitial extends UpdateExpenseState {}
final class UpdateExpenseLoading extends UpdateExpenseState {}
final class UpdateExpenseFailure extends UpdateExpenseState {
  final String message;

  const UpdateExpenseFailure({
    required this.message
  });
}

final class UpdateExpenseSuccess extends UpdateExpenseState {
  final String message;
  final ExpenseResponse response;

  const UpdateExpenseSuccess({
    required this.message,
    required this.response
  });
}