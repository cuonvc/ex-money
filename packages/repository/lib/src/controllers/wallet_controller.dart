import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:repository/src/utils/utils.dart';

import '../../repository.dart';

class WalletController {

  Future<dynamic> createWallet(String name, String description) async {
    Map requestBody = {
      'name': name,
      'description': description
    };

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    return http.post(
      Uri.parse('$domain/api/wallet?locale=vi'),
      headers: {
        'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
        'Content-Type': 'application/json'
      },
      body: json.encode(requestBody)
    );
  }

  Future<dynamic> getWalletList() async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    return http.get(
        Uri.parse('$domain/api/wallet/list?locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}'
        }
    );
  }

  Future<dynamic> changeUser(String action, String email, String walletId) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    return http.put(
      Uri.parse('$domain/api/wallet/change_user?locale=vi&action=$action&user_email=$email&wallet_id=$walletId'),
      headers: {
        'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
        'Content-Type': 'application/json'
      },
    );
  }

  Future<dynamic> changeExpenseLimit(String walletId, num amount) async {
    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();
    return http.put(
      Uri.parse('$domain/api/wallet/expense_limit?locale=vi&wallet_id=$walletId&amount=$amount'),
      headers: {
        'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
        'Content-Type': 'application/json'
      },
    );
  }
}