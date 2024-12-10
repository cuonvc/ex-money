import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'get_expense_filter_resource_event.dart';
part 'get_expense_filter_resource_state.dart';

class GetExpenseFilterResourceBloc extends Bloc<GetExpenseFilterResourceEvent, GetExpenseFilterResourceState> {

  final ExpenseRepository expenseRepository;

  GetExpenseFilterResourceBloc(this.expenseRepository) : super(GetExpenseFilterResourceInitial()) {
    on<GetExpenseFilterResourceEv>((event, emit) async {
      emit(GetExpenseFilterResourceLoading());
      try {
        HttpResponse response = await expenseRepository.getExpenseFilterResource(event.walletId);
        if (response.code == 0) {
          ExpenseFilterResource resource = ExpenseFilterResource.fromMap(response.data[0]);
          emit(GetExpenseFilterResourceSuccess(resource));
        } else {
          emit(GetExpenseFilterResourceFailure(response.message));
        }
      } catch (e) {
        log("Get expense resource for edit failure: $e");
        emit(GetExpenseFilterResourceFailure(e.toString()));
      }
    });
  }
}
