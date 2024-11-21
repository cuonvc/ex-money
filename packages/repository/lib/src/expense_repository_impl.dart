import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/expense_controller.dart';
import 'package:repository/src/utils/http_response.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {

  final expenseController = ExpenseController();

  @override
  Future<dynamic> getExpenseList(num? walletId) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await expenseController.getExpenseList(walletId)).bodyBytes));
      HttpResponse response = HttpResponse.toObject(mapResponse);
      if(response.code == 0) {
        log("Get expenses success");
        return response.data;
      } else {
        log("Get expenses failed");
        return null;
      }
    } catch (e) {
      log("Get expense error - $e");
      rethrow;
    }
  }

  @override
  Future getExpenseEditResource(num? walletId) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await expenseController.getExpenseResourceForEdit(walletId)).bodyBytes));
      HttpResponse response = HttpResponse.toObject(mapResponse);
      if(response.code == 0) {
        log("Get expense resource success");
        return response.data;
      } else {
        log(response.message);
        return null;
      }
    } catch (e) {
      log("Get expense resource error - $e");
      rethrow;
    }
  }

  @override
  Future addExpense(ExpenseCreateRequest request) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await expenseController.addExpense(request)).bodyBytes));
      HttpResponse response = HttpResponse.toObject(mapResponse);
      if(response.code == 0) {
        log("Add expense resource success");
        return response.data;
      } else {
        log(response.message);
        return null;
      }
    } catch (e) {
      log("Add expense resource error - $e");
      rethrow;
    }
  }



}