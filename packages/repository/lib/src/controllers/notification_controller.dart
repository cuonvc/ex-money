import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';
import 'package:repository/src/utils/utils.dart';

class NotificationController {
  Future<dynamic> markRead(num? id, bool all) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    Uri uri;
    if (all) {
      uri = Uri.parse('$domain/api/notification/mark_read/all?locale=vi');
    } else {
      uri = Uri.parse('$domain/api/notification/mark_read/$id?locale=vi');
    }

    return http.put(
        uri,
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}'
        }
    );
  }
}