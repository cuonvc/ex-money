import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'password_change_event.dart';
part 'password_change_state.dart';

class PasswordChangeBloc extends Bloc<PasswordChangeEvent, PasswordChangeState> {

  final UserRepository userRepository;

  PasswordChangeBloc(this.userRepository) : super(PasswordChangeInitial()) {
    on<PasswordChangeEv>((event, emit) async {
      emit(PasswordChangeLoading());
      try {
        HttpResponse response = await userRepository.changePassword(event.oldPassword, event.newPassword, event.confirmPassword);
        if (response.code == 0) {
          String message = response.message;
          emit(PasswordChangeSuccess(message: message));
        } else {
          emit(PasswordChangeFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to change password");
        emit(PasswordChangeFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
