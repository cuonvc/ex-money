import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notification_turn_event.dart';
part 'notification_turn_state.dart';

class NotificationTurnBloc extends Bloc<NotificationTurnEvent, NotificationTurnState> {

  final UserRepository userRepository;

  NotificationTurnBloc(this.userRepository) : super(NotificationTurnInitial()) {
    on<NotificationTurnEv>((event, emit) async {
      emit(NotificationTurnLoading());

      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.signInRespPref;

      try {
        emit(NotificationTurnLoading());

        HttpResponse response = await userRepository.turnNotification(event.on);
        if (response.code == 0) {
          bool turned = response.data[0];

          final Object? fromDisk = prefs.get(partOfPrefKey);
          List<dynamic> list = jsonDecode(fromDisk.toString());
          SignInResponse dataFromDisk = SignInResponse.fromMap(list);
          dataFromDisk.user.notificationOn = turned;

          await prefs.setString(partOfPrefKey, jsonEncode(SignInResponse.toMap(dataFromDisk)));
          emit(NotificationTurnSuccess(on: turned));
        } else {
          emit(NotificationTurnFailure(message: response.message));
        }
      } catch (e) {
        log("Failed to turn notification");
        emit(NotificationTurnFailure(message: "Có lỗi xảy ra \n${e.toString()}"));
      }
    });
  }
}
