import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'update_expense_scheduler_event.dart';
part 'update_expense_scheduler_state.dart';

class UpdateExpenseSchedulerBloc extends Bloc<UpdateExpenseSchedulerEvent, UpdateExpenseSchedulerState> {

  final TaskRepository taskRepository;

  UpdateExpenseSchedulerBloc(this.taskRepository) : super(UpdateExpenseSchedulerInitial()) {
    on<UpdateExpenseSchedulerEv>((event, emit) async {
      emit(UpdateExpenseSchedulerLoading());
      try {
        HttpResponse response = await taskRepository.updateExpenseScheduler(event.id, event.request);
        if (response.code == 0) {
          ExpenseSchedulerResponse task = ExpenseSchedulerResponse.fromMap(response.data[0]);
          emit(UpdateExpenseSchedulerSuccess(message: "Đã cập nhật chi tiêu tự động", response: task));
        } else {
          emit(UpdateExpenseSchedulerFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to update expense scheduler");
        emit(UpdateExpenseSchedulerFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
