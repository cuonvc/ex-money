import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:repository/repository.dart';
import 'package:repository/src/utils/utils.dart';

class TaskController {

  Future<dynamic> expenseSchedulerCreate(ExpenseSchedulerRequest request) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    return http.post(
        Uri.parse('$domain/api/task/expense_scheduler?locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
          'Content-Type': 'application/json'
        },
      body: jsonEncode(ExpenseSchedulerRequest.toMap(request))
    );
  }
}