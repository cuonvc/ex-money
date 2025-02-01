import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'get_confirm_expense_from_speech_event.dart';
part 'get_confirm_expense_from_speech_state.dart';

class GetConfirmExpenseFromSpeechBloc extends Bloc<GetConfirmExpenseFromSpeechEvent, GetConfirmExpenseFromSpeechState> {

  final ExpenseRepository expenseRepository;

  GetConfirmExpenseFromSpeechBloc(this.expenseRepository) : super(GetConfirmExpenseFromSpeechInitial()) {
    on<GetConfirmExpenseFromSpeechEv>((event, emit) async {
      emit(GetConfirmExpenseFromSpeechLoading());
      try {
        HttpResponse response = await expenseRepository.getConfirmExpenseFromSpeech(event.text);
        if (response.code == 0) {
          ExpenseConfirmResponse expense = ExpenseConfirmResponse.fromMap(response.data[0]);
          emit(GetConfirmExpenseFromSpeechSuccess(message: response.message, response: expense));
        } else {
          emit(GetConfirmExpenseFromSpeechFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to create expense");
        emit(GetConfirmExpenseFromSpeechFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
