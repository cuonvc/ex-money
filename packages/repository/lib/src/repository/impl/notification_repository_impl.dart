import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/notification_controller.dart';
import 'package:repository/src/repository/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {

  final notificationController = NotificationController();
  final userRepository = UserRepositoryImpl();

  @override
  Future markRead(num? id, bool all) async {
    try {
      var resp = await notificationController.markRead(id, all);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await notificationController.markRead(id, all);
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Mark read notification error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

}