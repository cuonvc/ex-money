part of 'get_expense_filter_resource_bloc.dart';

sealed class GetExpenseFilterResourceState extends Equatable {
  const GetExpenseFilterResourceState();

  @override
  List<Object> get props => [];
}

final class GetExpenseFilterResourceInitial extends GetExpenseFilterResourceState {}
final class GetExpenseFilterResourceLoading extends GetExpenseFilterResourceState {}
final class GetExpenseFilterResourceFailure extends GetExpenseFilterResourceState {
  final String message;

  const GetExpenseFilterResourceFailure(this.message);
}
final class GetExpenseFilterResourceSuccess extends GetExpenseFilterResourceState {
  final ExpenseFilterResource resource;

  const GetExpenseFilterResourceSuccess(this.resource);
}