part of 'delete_expense_bloc.dart';

sealed class DeleteExpenseState extends Equatable {
  const DeleteExpenseState();

  @override
  List<Object> get props => [];
}

final class DeleteExpenseInitial extends DeleteExpenseState {}
final class DeleteExpenseLoading extends DeleteExpenseState {}
final class DeleteExpenseFailure extends DeleteExpenseState {
  final int statusCode;
  final String message;

  const DeleteExpenseFailure({
    required this.statusCode,
    required this.message
  });
}

final class DeleteExpenseSuccess extends DeleteExpenseState {
  final String message;

  const DeleteExpenseSuccess(this.message);
}
