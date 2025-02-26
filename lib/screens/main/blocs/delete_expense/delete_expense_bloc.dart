import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'delete_expense_event.dart';
part 'delete_expense_state.dart';

class DeleteExpenseBloc extends Bloc<DeleteExpenseEvent, DeleteExpenseState> {

  final ExpenseRepository expenseRepository;

  DeleteExpenseBloc(this.expenseRepository) : super(DeleteExpenseInitial()) {
    on<DeleteExpenseEv>((event, emit) async {
      emit(DeleteExpenseLoading());
      try {
        HttpResponse response = await expenseRepository.deleteExpense(event.id);
        if (response.code == 0) {
          String message = response.message;
          emit(DeleteExpenseSuccess(message));
        } else {
          emit(DeleteExpenseFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Failed to create expense");
        emit(DeleteExpenseFailure(statusCode: 1, message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
