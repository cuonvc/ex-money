import 'package:http/http.dart' as http;
import 'package:repository/src/utils/constant.dart';

class CategoryController {

  Future<dynamic> getCategoryList(num? walletId) async {
    String id = walletId == null ? "" : walletId.toString();
    return http.get(
        Uri.parse('$domain/api/category?save_type=WALLET&ref_id=$id&locale=vi'),
        headers: {
          // 'Accept-Language': 'vi', //required
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }
}