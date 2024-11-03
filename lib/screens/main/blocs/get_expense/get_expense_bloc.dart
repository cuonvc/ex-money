import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'get_expense_event.dart';
part 'get_expense_state.dart';

class GetExpenseBloc extends Bloc<GetExpenseEvent, GetExpenseState> {

  final ExpenseRepository expenseRepository;

  GetExpenseBloc(this.expenseRepository) : super(GetExpenseInitial()) {
    on<GetExpenseEv>((event, emit) async {
      emit(GetExpenseLoading());
      try {
        List data = await expenseRepository.getExpenseList(event.walletId);
        emit(GetExpenseSuccess(data[0]));
      } catch (e) {
        log("Get Expense failed: $e");
        emit(GetExpenseFailure());
      }
    });
  }
}
