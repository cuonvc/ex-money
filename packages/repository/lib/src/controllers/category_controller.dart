import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';
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

  Future<dynamic> saveCategory(num? id, ExpenseCategoryRequest request) async {
    Object body = json.encode(ExpenseCategoryRequest.toMap(request));
    if (id == null) {
      //create
      return http.post(
          Uri.parse('$domain/api/category?locale=vi'),
          headers: {
            'Authorization': 'Bearer $accessTokenTest',
            'Content-Type': 'application/json'
          },
          body: body
      );
    } else {
      //update
      return http.put(
          Uri.parse('$domain/api/category/$id?locale=vi'),
          headers: {
            'Authorization': 'Bearer $accessTokenTest',
            'Content-Type': 'application/json'
          },
          body: body
      );
    }

  }
}