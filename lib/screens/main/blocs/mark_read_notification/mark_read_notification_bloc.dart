import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mark_read_notification_event.dart';
part 'mark_read_notification_state.dart';

class MarkReadNotificationBloc extends Bloc<MarkReadNotificationEvent, MarkReadNotificationState> {

  final NotificationRepository notificationRepository;

  MarkReadNotificationBloc(this.notificationRepository) : super(MarkReadNotificationInitial()) {
    on<MarkReadNotificationEv>((event, emit) async {
      emit(MarkReadNotificationLoading());

      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.homeOverviewPref;

      try {
        HttpResponse response = await notificationRepository.markRead(event.id, event.all);
        if (response.code == 0) {
          bool seen = response.data[0];
          emit(MarkReadNotificationSuccess(result: seen));

          if (seen) {
            final Object? dataCached = prefs.get(partOfPrefKey);
            if (dataCached != null) {
              Map<String, dynamic> fromDisk = jsonDecode(dataCached.toString());
              HomeOverviewResponse dataFromDisk = HomeOverviewResponse.fromMap(fromDisk);
              List<NotificationResponse> notifications = dataFromDisk.notifications;
              if (event.all) {
                for (NotificationResponse item in notifications) {
                  item.seen = true;
                }
              } else {
                for (NotificationResponse item in notifications) {
                  if (item.id == event.id) {
                    item.seen = true;
                  }
                }
              }
            }
          }
        } else {
          emit(MarkReadNotificationFailure(message: response.message));
        }
      } catch (e) {
        log("Mark read notification failed: $e");
        emit(MarkReadNotificationFailure(message: e.toString()));
      }
    });
  }
}
