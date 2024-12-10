import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';

import '../utils/constant.dart';

class ExpenseController {

  Future<dynamic> getExpenseList(num? walletId, String? keyword, num? categoryId, num? createdById) async {
    String wallet = walletId == null ? "" : walletId.toString();
    keyword = keyword == null ? "" : keyword;
    String category = categoryId == null ? "" : categoryId.toString();
    String createdBy = createdById == null ? "" : createdById.toString();
    return http.get(
        Uri.parse('$domain/api/expense?wallet_id=$wallet&keyword=$keyword&category_id=$category&created_by=$createdBy&locale=vi'),
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

  Future<dynamic> getExpenseResourceForFilter(num? walletId) async {
    String id = walletId == null ? "" : walletId.toString();
    return http.get(
        Uri.parse('$domain/api/expense/filter_resource?wallet_id=$id&locale=vi'),
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