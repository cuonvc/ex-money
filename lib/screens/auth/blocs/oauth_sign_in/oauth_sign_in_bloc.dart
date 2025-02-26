import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'oauth_sign_in_event.dart';
part 'oauth_sign_in_state.dart';

class OAuthSignInBloc extends Bloc<OAuthSignInEvent, OAuthSignInState> {

  final UserRepository userRepository;

  OAuthSignInBloc(this.userRepository) : super(OAuthSignInInitial()) {
    on<OAuthSignInEv>((event, emit) async {
      emit(OAuthSignInLoading());
      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.signInRespPref;

      try {
        emit(OAuthSignInLoading());

        HttpResponse response = await userRepository.oAuthSignIn(event.token, event.provider);
        if (response.code == 0) {
          SignInResponse signInResponse = SignInResponse.fromMap(response.data);

          await prefs.setString(partOfPrefKey, jsonEncode(response.data));
          emit(OAuthSignInSuccess(response: signInResponse));
        } else {
          emit(OAuthSignInFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Failed to Login via ${event.provider}");
        emit(OAuthSignInFailure(statusCode: 1, message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
