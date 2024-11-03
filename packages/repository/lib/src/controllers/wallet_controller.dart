import 'package:http/http.dart' as http;
import 'package:repository/src/utils/constant.dart';

class WalletController {
  Future<dynamic> getWalletDetail(String walletId) async {
    return http.get(
        Uri.parse('$domain/api/wallet/$walletId?locale=vi'),
        headers: {
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }
}