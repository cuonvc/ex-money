part of 'delete_expense_bloc.dart';

sealed class DeleteExpenseEvent extends Equatable {
  const DeleteExpenseEvent();

  @override
  List<Object> get props => [];
}

class DeleteExpenseEv extends DeleteExpenseEvent {
  final num id;

  const DeleteExpenseEv(this.id);
}
