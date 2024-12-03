import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final ExpenseRepository expenseRepository;

  AddExpenseBloc(this.expenseRepository) : super(AddExpenseInitial()) {
    on<AddExpenseEv>((event, emit) async {
      emit(AddExpenseLoading());
      try {
        HttpResponse response = await expenseRepository.addExpense(event.request);
        if (response.code == 0) {
          ExpenseResponse expense = ExpenseResponse.fromMap(response.data[0]);
          emit(AddExpenseSuccess(expense: expense));
        } else {
          emit(AddExpenseFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to create expense");
        emit(AddExpenseFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
