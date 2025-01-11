import 'package:http/http.dart' as http;
import 'package:repository/src/utils/constant.dart';

class OverviewController {
  Future<dynamic> getHomeOverviewController(int? month, int? year) async {
    String monthStr = month == null ? "" : month.toString();
    String yearStr = year == null ? "" : year.toString();
    return http.get(
        Uri.parse('$domain/api/overview?month=$monthStr&year=$yearStr&locale=vi'),
        headers: {
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }
}