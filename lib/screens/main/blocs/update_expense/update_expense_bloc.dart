import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'update_expense_event.dart';
part 'update_expense_state.dart';

class UpdateExpenseBloc extends Bloc<UpdateExpenseEvent, UpdateExpenseState> {

  final ExpenseRepository expenseRepository;

  UpdateExpenseBloc(this.expenseRepository) : super(UpdateExpenseInitial()) {
    on<UpdateExpenseEv>((event, emit) async {
      emit(UpdateExpenseLoading());
      try {
        HttpResponse response = await expenseRepository.updateExpense(event.id, event.request);
        if (response.code == 0) {
          ExpenseResponse expense = ExpenseResponse.fromMap(response.data[0]);
          emit(UpdateExpenseSuccess(message: "Đã cập nhật chi tiêu", response: expense));
        } else {
          emit(UpdateExpenseFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to update expense");
        emit(UpdateExpenseFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
