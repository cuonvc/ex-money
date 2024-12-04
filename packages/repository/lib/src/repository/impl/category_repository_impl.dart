import 'dart:convert';
import 'dart:developer';

import 'package:repository/src/repository/category_repository.dart';
import 'package:repository/src/controllers/category_controller.dart';
import 'package:repository/src/utils/http_response.dart';

class CategoryRepositoryImpl extends CategoryRepository {

  final categoryController = CategoryController();

  @override
  Future getCategoryList(num? walletId) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await categoryController.getCategoryList(walletId)).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Get category error - $e");
      return HttpResponse.toError(e.toString());
    }
  }

}