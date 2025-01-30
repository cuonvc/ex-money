import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'create_expense_scheduler_event.dart';
part 'create_expense_scheduler_state.dart';

class CreateExpenseSchedulerBloc extends Bloc<CreateExpenseSchedulerEvent, CreateExpenseSchedulerState> {

  final TaskRepository taskRepository;

  CreateExpenseSchedulerBloc(this.taskRepository) : super(CreateExpenseSchedulerInitial()) {
    on<CreateExpenseSchedulerEv>((event, emit) async {
      emit(CreateExpenseSchedulerLoading());
      try {
        HttpResponse response = await taskRepository.createExpenseScheduler(event.request);
        if (response.code == 0) {
          ExpenseSchedulerResponse task = ExpenseSchedulerResponse.fromMap(response.data[0]);
          emit(CreateExpenseSchedulerSuccess(response: task));
        } else {
          emit(CreateExpenseSchedulerFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to create expense scheduler");
        emit(CreateExpenseSchedulerFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
