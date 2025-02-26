import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'active_account_event.dart';
part 'active_account_state.dart';

class ActiveAccountBloc extends Bloc<ActiveAccountEvent, ActiveAccountState> {

  final UserRepository userRepository;

  ActiveAccountBloc(this.userRepository) : super(ActiveAccountInitial()) {
    on<ActiveAccountEv>((event, emit) async {
      try {
        emit(ActiveAccountLoading());

        HttpResponse response = await userRepository.activeAccount(event.model, event.activeCode);
        if (response.code == 0) {
          emit(ActiveAccountSuccess(message: response.message));
        } else {
          emit(ActiveAccountFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Failed to Sign up");
        emit(ActiveAccountFailure(statusCode: 1, message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
