part of 'get_expense_bloc.dart';

sealed class GetExpenseEvent extends Equatable {
  const GetExpenseEvent();

  @override
  List<Object?> get props => [];
}

class GetExpenseEv extends GetExpenseEvent {
  ExpenseResponse? expenseResponse;
  num? walletId;
  String? keyword;
  num? categoryId;
  num? createdById;

  GetExpenseEv(this.walletId, this.keyword, this.categoryId, this.createdById);
}

