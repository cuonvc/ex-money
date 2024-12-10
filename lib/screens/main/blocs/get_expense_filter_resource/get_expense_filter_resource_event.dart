part of 'get_expense_filter_resource_bloc.dart';

sealed class GetExpenseFilterResourceEvent extends Equatable {
  const GetExpenseFilterResourceEvent();

  @override
  List<Object> get props => [];
}

class GetExpenseFilterResourceEv extends GetExpenseFilterResourceEvent {
  ExpenseFilterResource? resource;
  num? walletId;

  GetExpenseFilterResourceEv(this.walletId);
}
