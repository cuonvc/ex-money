import 'dart:convert';
import 'dart:developer';

import 'package:repository/src/controllers/wallet_controller.dart';
import 'package:repository/src/repository/wallet_repository.dart';
import 'package:repository/src/utils/http_response.dart';

class WalletRepositoryImpl implements WalletRepository {

  final walletController = Walletcontroller();

  @override
  Future<dynamic> getWalletList() async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await walletController.getWalletList()).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error cached - ${e.toString()}');
      return HttpResponse.toError(e.toString());
    }
  }

  @override
  Future changeUser(String action, String email, String walletId ) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await walletController.changeUser(action, email, walletId)).bodyBytes));
      HttpResponse response = HttpResponse.toObject(mapResponse);

      if(response.code == 0) {
        log("Change user in wallet success");
        return response;
      } else {
        log("Change user in wallet failed");
        return response;
      }
    } catch (e) {
      log('Error cached - ${e.toString()}');
      rethrow;
    }
  }

}