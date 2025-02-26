import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_out_event.dart';
part 'sign_out_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {

  final UserRepository userRepository;

  SignOutBloc(this.userRepository) : super(SignOutInitial()) {
    on<SignOutEv>((event, emit) async {
      emit(SignOutLoading());
      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      // final partOfPrefKey = CachedPrefKey.signInRespPref;

      try {
        emit(SignOutLoading());

        HttpResponse response = await userRepository.signOut();
        if (response.code == 0) {

          await prefs.clear();
          emit(SignOutSuccess());
        } else {
          emit(SignOutFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Failed to Log out");
        emit(SignOutFailure(statusCode: 1, message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
