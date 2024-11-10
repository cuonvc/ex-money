import 'package:http/http.dart' as http;

import '../utils/constant.dart';

class ExpenseController {

  Future<dynamic> getExpenseList(String? walletId) async {
    walletId = walletId ?? '';
    return http.get(
        Uri.parse('$domain/api/expense?wallet_id=$walletId&locale=vi'),
        headers: {
          // 'Accept-Language': 'vi', //required
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }

  Future<dynamic> getExpenseResourceForEdit(String? walletId) async {
    walletId = walletId ?? '';
    return http.get(
        Uri.parse('$domain/api/expense/edit_resource?wallet_id=$walletId&locale=vi'),
        headers: {
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }
}