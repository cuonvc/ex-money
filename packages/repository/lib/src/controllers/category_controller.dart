import 'package:http/http.dart' as http;
import 'package:repository/src/utils/constant.dart';

class CategoryController {

  Future<dynamic> getCategoryList(String? walletId) async {
    walletId = walletId ?? '';
    return http.get(
        Uri.parse('$domain/api/category?save_type=WALLET&ref_id=$walletId&locale=vi'),
        headers: {
          // 'Accept-Language': 'vi', //required
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }
}