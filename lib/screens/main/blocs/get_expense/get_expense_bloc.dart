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
        HttpResponse response = await expenseRepository.getExpenseList(
            event.walletId, event.keyword, event.categoryId, event.createdById
        );
        if (response.code == 0) {
          List list = response.data[0];
          List<ExpenseResponse> dataList = list.map((e) => ExpenseResponse.fromMap(e)).toList();
          emit(GetExpenseSuccess(dataList));
        }
      } catch (e) {
        log("Get Expense failed: $e");
        emit(GetExpenseFailure(e.toString()));
      }
    });
  }
}
