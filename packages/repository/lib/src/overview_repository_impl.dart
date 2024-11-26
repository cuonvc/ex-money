import 'dart:convert';
import 'dart:developer';

import 'package:repository/src/controllers/overview_controller.dart';
import 'package:repository/src/utils/http_response.dart';
import 'package:repository/src/overview_repository.dart';

class OverviewRepositoryImpl implements OverviewRepository {

  final overviewController = OverviewController();

  @override
  Future<dynamic> getHomeOverview(int? month) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await overviewController.getHomeOverviewController(month)).bodyBytes));
      HttpResponse response = HttpResponse.toObject(mapResponse);

      if(response.code == 0) {
        log("Get home overview  success");
        return response.data;
      } else {
        log("Get home overview failed");
        return null;
      }
    } catch (e) {
      log('Error cached - ${e.toString()}');
      rethrow;
    }
  }
}