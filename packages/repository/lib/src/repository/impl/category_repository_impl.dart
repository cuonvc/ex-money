import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/category_controller.dart';

class CategoryRepositoryImpl extends CategoryRepository {

  final categoryController = CategoryController();
  final userRepository = UserRepositoryImpl();

  @override
  Future getCategoryList(num? walletId, String keyword) async {
    try {
      var resp = await categoryController.getCategoryList(walletId, keyword);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await categoryController.getCategoryList(walletId, keyword);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Get category error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future saveCategory(num? id, ExpenseCategoryRequest request) async {
    try {
      var resp = await categoryController.saveCategory(id, request);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await categoryController.saveCategory(id, request);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Save category error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future deleteById(num id) async {
    try {
      var resp = await categoryController.deleteCategory(id);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await categoryController.deleteCategory(id);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Delete category error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }



}