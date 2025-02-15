import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/overview_controller.dart';

class OverviewRepositoryImpl implements OverviewRepository {

  final overviewController = OverviewController();
  final UserRepository userRepository = UserRepositoryImpl();

  @override
  Future<dynamic> getHomeOverview(int? month, int? year) async {
    try {
      var rp = await overviewController.getHomeOverviewController(month, year);
      if (rp.statusCode == 401) {
        await userRepository.renewAccessToken();
        rp = await overviewController.getHomeOverviewController(month, year);
      } else if (rp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(await rp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error cached - ${e.toString()}');
      return HttpResponse.toError(e.toString(), null);
    }
  }
}