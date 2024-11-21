import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';

import '../utils/constant.dart';

class ExpenseController {

  Future<dynamic> getExpenseList(num? walletId) async {
    return http.get(
        Uri.parse('$domain/api/expense?wallet_id=$walletId&locale=vi'),
        headers: {
          // 'Accept-Language': 'vi', //required
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }

  Future<dynamic> getExpenseResourceForEdit(num? walletId) async {
    String id = walletId == null ? "" : walletId.toString();
    return http.get(
        Uri.parse('$domain/api/expense/edit_resource?wallet_id=$id&locale=vi'),
        headers: {
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }

  Future<dynamic> addExpense(ExpenseCreateRequest request) async {
    return http.post(
      Uri.parse('$domain/api/expense?locale=vi'),
      headers: {
        'Authorization': 'Bearer $accessTokenTest',
        'Content-Type': 'application/json'
      },
      body: json.encode(ExpenseCreateRequest.toMap(request))
    );
  }
}