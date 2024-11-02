import 'package:http/http.dart' as http;

import '../utils/constant.dart';

class ExpenseController {

  Future<dynamic> getExpenseList() async {
    return http.get(
        Uri.parse('$domain/api/expense/list?locale=vi'),
        headers: {
          // 'Accept-Language': 'vi', //required
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }
}