import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';
import 'package:repository/src/utils/utils.dart';

class CategoryController {

  Future<dynamic> getCategoryList(num? walletId) async {
    String id = walletId == null ? "" : walletId.toString();

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    return http.get(
        Uri.parse('$domain/api/category?save_type=WALLET&ref_id=$id&locale=vi'),
        headers: {
          // 'Accept-Language': 'vi', //required
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}'
        }
    );
  }

  Future<dynamic> saveCategory(num? id, ExpenseCategoryRequest request) async {
    Object body = json.encode(ExpenseCategoryRequest.toMap(request));
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    if (id == null) {
      //create
      return http.post(
          Uri.parse('$domain/api/category?locale=vi'),
          headers: {
            'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
            'Content-Type': 'application/json'
          },
          body: body
      );
    } else {
      //update
      return http.put(
          Uri.parse('$domain/api/category/$id?locale=vi'),
          headers: {
            'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
            'Content-Type': 'application/json'
          },
          body: body
      );
    }

  }
}