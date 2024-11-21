import 'package:http/http.dart' as http;
import 'package:repository/src/utils/constant.dart';

class WalletController {
  Future<dynamic> getWalletDetail(num? walletId) async {
    String id = walletId == null ? "" : walletId.toString();
    return http.get(
        Uri.parse('$domain/api/wallet/detail?id=$id&locale=vi'),
        headers: {
          'Authorization': 'Bearer $accessTokenTest'
        }
    );
  }
}