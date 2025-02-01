import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';
import 'package:repository/src/utils/utils.dart';

import '../utils/constant.dart';

class ExpenseController {

  Future<dynamic> getExpenseList(num? walletId, String? keyword, num? categoryId, num? createdById, String? startDate, String? endDate) async {
    String wallet = walletId == null ? "" : walletId.toString();
    keyword = keyword == null ? "" : keyword;
    String category = categoryId == null ? "" : categoryId.toString();
    String createdBy = createdById == null ? "" : createdById.toString();
    startDate = startDate == null ? "" : startDate;
    endDate = endDate == null ? "" : endDate;

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    return http.get(
        Uri.parse('$domain/api/expense?wallet_id=$wallet&keyword=$keyword&category_id=$category&created_by=$createdBy&start_time=$startDate&end_time=$endDate&locale=vi'),
        headers: {
          // 'Accept-Language': 'vi', //required
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}'
        }
    );
  }

  Future<dynamic> getExpenseResourceForEdit(num? walletId) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    String id = walletId == null ? "" : walletId.toString();
    return http.get(
        Uri.parse('$domain/api/expense/edit_resource?wallet_id=$id&locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}'
        }
    );
  }

  Future<dynamic> getExpenseResourceForFilter(num? walletId) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    String id = walletId == null ? "" : walletId.toString();
    return http.get(
        Uri.parse('$domain/api/expense/filter_resource?wallet_id=$id&locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}'
        }
    );
  }

  Future<dynamic> addExpense(ExpenseCreateRequest request) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    return http.post(
      Uri.parse('$domain/api/expense?locale=vi'),
      headers: {
        'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
        'Content-Type': 'application/json'
      },
      body: json.encode(ExpenseCreateRequest.toMap(request))
    );
  }

  Future<dynamic> updateExpense(num id, ExpenseUpdateRequest request) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    return http.put(
        Uri.parse('$domain/api/expense/$id?locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
          'Content-Type': 'application/json'
        },
        body: json.encode(ExpenseUpdateRequest.toMap(request))
    );
  }

  Future<dynamic> deleteExpense(num id) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    return http.delete(
        Uri.parse('$domain/api/expense/$id?locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
          'Content-Type': 'application/json'
        }
    );
  }

  Future<dynamic> getConfirmExpenseFromSpeech(String text) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    return http.post(
        Uri.parse('$domain/api/expense/speech?locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
          'Content-Type': 'application/json'
        },
      body: text
    );
  }
}