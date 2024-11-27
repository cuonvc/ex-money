import 'package:http/http.dart' as http;

import '../../repository.dart';

class Walletcontroller {
  Future<dynamic> getWalletList() async {
    return http.get(
        Uri.parse('$domain/api/wallet/list?locale=vi'),
        headers: {
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }
}