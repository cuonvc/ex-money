import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/expense_controller.dart';
import 'package:repository/src/repository/expense_repository.dart';
import 'package:repository/src/utils/http_response.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {

  final expenseController = ExpenseController();

  @override
  Future<dynamic> getExpenseList(num? walletId) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await expenseController.getExpenseList(walletId)).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Get expense error - $e");
      return HttpResponse.toError(e.toString());
    }
  }

  @override
  Future getExpenseEditResource(num? walletId) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await expenseController.getExpenseResourceForEdit(walletId)).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Get expense resource error - $e");
      return HttpResponse.toError(e.toString());
    }
  }

  @override
  Future addExpense(ExpenseCreateRequest request) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await expenseController.addExpense(request)).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Add expense resource error - $e");
      return HttpResponse.toError(e.toString());
    }
  }



}