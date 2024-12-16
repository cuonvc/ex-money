import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../repository.dart';

class WalletController {

  Future<dynamic> createWallet(String name, String description) async {
    Map requestBody = {
      'name': name,
      'description': description
    };

    return http.post(
      Uri.parse('$domain/api/wallet?locale=vi'),
      headers: {
        'Authorization': 'Bearer $accessTokenTest',
        'Content-Type': 'application/json'
      },
      body: json.encode(requestBody)
    );
  }

  Future<dynamic> getWalletList() async {
    return http.get(
        Uri.parse('$domain/api/wallet/list?locale=vi'),
        headers: {
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }

  Future<dynamic> changeUser(String action, String email, String walletId) async {
    return http.put(
      Uri.parse('$domain/api/wallet/change_user?locale=vi&action=$action&user_email=$email&wallet_id=$walletId'),
      headers: {
        'Authorization': 'Bearer $accessTokenTest',
        'Content-Type': 'application/json'
      },
    );
  }
}