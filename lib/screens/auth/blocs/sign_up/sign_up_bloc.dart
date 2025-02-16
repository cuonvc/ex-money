import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  final UserRepository userRepository;

  SignUpBloc(this.userRepository) : super(SignUpInitial()) {
    on<SignUpEv>((event, emit) async {
      try {
        emit(SignUpLoading());

        HttpResponse response = await userRepository.signUp(event.model);
        if (response.code == 0) {
          String email = response.data[0];
          String timeLimit = response.data[1];
          String message = response.message.replaceFirst("{0}", email); //chỉ replace email thôi, time để update động trong screen

          emit(SignUpSuccess(email: email, limitTime: timeLimit, message: message));
        } else {
          emit(SignUpFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to Sign up");
        emit(SignUpFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
