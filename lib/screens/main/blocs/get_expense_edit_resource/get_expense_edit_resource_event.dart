part of 'get_expense_edit_resource_bloc.dart';

sealed class GetExpenseEditResourceEvent extends Equatable {
  const GetExpenseEditResourceEvent();

  @override
  List<Object?> get props => [];
}

class GetExpenseEditResourceEv extends GetExpenseEditResourceEvent {
  ExpenseEditResource? expenseEditResource;
  num? walletId;

  GetExpenseEditResourceEv(this.walletId);

  @override
  List<Object?> get props => [expenseEditResource];
}