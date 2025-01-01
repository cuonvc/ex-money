part of 'get_expense_filter_resource_bloc.dart';

sealed class GetExpenseFilterResourceEvent extends Equatable {
  const GetExpenseFilterResourceEvent();

  @override
  List<Object> get props => [];
}

class GetExpenseFilterResourceEv extends GetExpenseFilterResourceEvent {
  ExpenseFilterResource? resource;
  num? walletId;
  bool isReload;
  bool isCache;

  GetExpenseFilterResourceEv({
    required this.walletId,
    required this.isReload,
    required this.isCache
  });
}
