part of 'get_expense_edit_resource_bloc.dart';

sealed class GetExpenseEditResourceState extends Equatable {
  const GetExpenseEditResourceState();
  List<Object?> get props => [];
}

// final class GetExpenseEditResourceInitial extends GetExpenseEditResourceState {}
// final class GetExpenseEditResourceLoading extends GetExpenseEditResourceState {}
// final class GetExpenseEditResourceFailure extends GetExpenseEditResourceState {}
// final class GetExpenseEditResourceSuccess extends GetExpenseEditResourceState {
//   final List data;
//
//   const GetExpenseEditResourceSuccess(this.data);
//
//   @override
//   List<Object?> get props => data;
// }


final class GetExpenseEditResourceInitial extends GetExpenseEditResourceState {}
final class GetExpenseEditResourceLoading extends GetExpenseEditResourceState {}
final class GetExpenseEditResourceFailure extends GetExpenseEditResourceState {
  final String message;

  const GetExpenseEditResourceFailure(this.message);
}
final class GetExpenseEditResourceSuccess extends GetExpenseEditResourceState {
  final ExpenseEditResource resource;

  const GetExpenseEditResourceSuccess(this.resource);
}
