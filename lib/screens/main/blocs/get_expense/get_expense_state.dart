part of 'get_expense_bloc.dart';

sealed class GetExpenseState extends Equatable {
  const GetExpenseState();
  List<Object?> get props => [];
}

final class GetExpenseInitial extends GetExpenseState {}
final class GetExpenseFailure extends GetExpenseState {}
final class GetExpenseLoading extends GetExpenseState {}
final class GetExpenseSuccess extends GetExpenseState {
  final List data;
  const GetExpenseSuccess(this.data);

  @override
  List<Object?> get props => data;
}
