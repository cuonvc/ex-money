import 'dart:convert';
import 'dart:developer';

import 'package:repository/src/controllers/overview_controller.dart';
import 'package:repository/src/repository/overview_repository.dart';
import 'package:repository/src/utils/http_response.dart';

class OverviewRepositoryImpl implements OverviewRepository {

  final overviewController = OverviewController();

  @override
  Future<dynamic> getHomeOverview(int? month) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await overviewController.getHomeOverviewController(month)).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error cached - ${e.toString()}');
      return HttpResponse.toError(e.toString());
    }
  }
}