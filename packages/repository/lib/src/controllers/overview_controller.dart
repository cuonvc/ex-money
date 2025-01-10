import 'package:http/http.dart' as http;
import 'package:repository/src/utils/constant.dart';

class OverviewController {
  Future<dynamic> getHomeOverviewController(int? month) async {
    String monthStr = month == null ? "" : month.toString();
    return http.get(
        Uri.parse('$domain/api/overview?month=12&year=2024&locale=vi'),
        headers: {
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }
}