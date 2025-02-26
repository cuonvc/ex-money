import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'account_setting_event.dart';
part 'account_setting_state.dart';

class AccountSettingBloc extends Bloc<AccountSettingEvent, AccountSettingState> {

  final UserRepository userRepository;

  AccountSettingBloc(this.userRepository) : super(AccountSettingInitial()) {
    on<AccountSettingEv>((event, emit) async {
      emit(AccountSettingLoading());

      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.signInRespPref;

      try {
        emit(AccountSettingLoading());

        HttpResponse response = await userRepository.updateProfile(event.name);
        if (response.code == 0) {
          UserResponse userResponse = UserResponse.fromMap(response.data[0]);

          final Object? fromDisk = prefs.get(partOfPrefKey);
          List<dynamic> list = jsonDecode(fromDisk.toString());
          SignInResponse dataFromDisk = SignInResponse.fromMap(list);
          dataFromDisk.user = userResponse;

          await prefs.setString(partOfPrefKey, jsonEncode(SignInResponse.toMap(dataFromDisk)));
          emit(AccountSettingSuccess(data: userResponse));
        } else {
          emit(AccountSettingFailure(statusCode: response.statusCode, message: response.message));
        }
      } catch (e) {
        log("Failed to update profile");
        emit(AccountSettingFailure(statusCode: 1, message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
