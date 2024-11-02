import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/expense_controller.dart';
import 'package:repository/src/utils/http_response.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {

  final expenseController = ExpenseController();

  @override
  Future<dynamic> getExpenseList() async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await expenseController.getExpenseList()).bodyBytes));
      HttpResponse response = HttpResponse.toObject(mapResponse);
      if(response.code == 0) {
        log("Login success");
        return response.data;
      } else {
        log("Login failed");
        return null;
      }
    } catch (e) {
      log("Get expense error - $e");
      rethrow;
    }
  }


}