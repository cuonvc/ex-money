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
  String? startDate;
  String? endDate;

  GetExpenseEv({
    required this.walletId,
    required this.keyword,
    required this.categoryId,
    required this.createdById,
    required this.startDate,
    required this.endDate
  });
}

