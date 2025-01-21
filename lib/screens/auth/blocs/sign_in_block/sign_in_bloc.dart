import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {

  final UserRepository userRepository;

  SignInBloc(this.userRepository) : super(SignInInitial()) {
    on<SignInEv>((event, emit) async {

      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.signInRespPref;

      try {
        emit(SignInLoading());

        HttpResponse response = await userRepository.signIn(event.signInModel);
        if (response.code == 0) {
          SignInResponse signInResponse = SignInResponse.fromMap(response.data);

          await prefs.setString(partOfPrefKey, jsonEncode(response.data));
          emit(SignInSuccess(response: signInResponse));
        } else {
          emit(SignInFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Failed to Login");
        emit(SignInFailure(statusCode: 0, message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
