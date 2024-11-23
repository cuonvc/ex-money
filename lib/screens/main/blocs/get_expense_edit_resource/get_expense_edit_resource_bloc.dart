import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'get_expense_edit_resource_event.dart';
part 'get_expense_edit_resource_state.dart';

class GetExpenseEditResourceBloc extends Bloc<GetExpenseEditResourceEvent, GetExpenseEditResourceState> {

  final ExpenseRepository expenseRepository;

  GetExpenseEditResourceBloc(this.expenseRepository) : super(GetExpenseEditResourceInitial()) {
    on<GetExpenseEditResourceEv>((event, emit) async {
      emit(GetExpenseEditResourceLoading());
      try {
        List data = await expenseRepository.getExpenseEditResource(event.walletId);
        emit(GetExpenseEditResourceSuccess(data));
      } catch (e) {
        log("Get expense resource for edit failure: $e");
        emit(GetExpenseEditResourceFailure());
      }
    });
  }
}