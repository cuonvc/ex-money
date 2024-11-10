import 'dart:convert';
import 'dart:developer';

import 'package:repository/src/category_repository.dart';
import 'package:repository/src/controllers/category_controller.dart';
import 'package:repository/src/utils/http_response.dart';

class CategoryRepositoryImpl extends CategoryRepository {

  final categoryController = CategoryController();

  @override
  Future getCategoryList(String? walletId) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await categoryController.getCategoryList(walletId)).bodyBytes));
      HttpResponse response = HttpResponse.toObject(mapResponse);
      if(response.code == 0) {
        log("Get category success");
        return response.data;
      } else {
        log("Get category failed: ${response.message}");
        return null;
      }
    } catch (e) {
      log("Get category error - $e");
      rethrow;
    }
  }

}