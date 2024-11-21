import 'dart:convert';
import 'dart:developer';

import 'package:repository/src/controllers/wallet_controller.dart';
import 'package:repository/src/utils/http_response.dart';
import 'package:repository/src/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {

  final walletController = WalletController();

  @override
  Future<dynamic> getWalletDetail(num? walletId) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await walletController.getWalletDetail(walletId)).bodyBytes));
    HttpResponse response = HttpResponse.toObject(mapResponse);

    if(response.code == 0) {
    log("Get wallet  success");
    return response.data;
    } else {
    log("Get wallet  failed");
    return null;
    }
    } catch (e) {
    log('Error cached - ${e.toString()}');
    rethrow;
    }
  }
}