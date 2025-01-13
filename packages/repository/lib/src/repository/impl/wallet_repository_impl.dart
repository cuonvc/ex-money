import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/wallet_controller.dart';

class WalletRepositoryImpl implements WalletRepository {

  final walletController = WalletController();
  final userRepository = UserRepositoryImpl();

  @override
  Future<dynamic> createWallet(String name, String description) async {
    try {
      var resp = await walletController.createWallet(name, description);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await walletController.createWallet(name, description);
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error cached - ${e.toString()}');
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future<dynamic> getWalletList() async {
    try {
      var resp = await walletController.getWalletList();
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await walletController.getWalletList();
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error cached - ${e.toString()}');
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future changeUser(String action, String email, String walletId ) async {
    try {
      var resp = await walletController.changeUser(action, email, walletId);
      if (resp.statusCode == 401) {
        await userRepository.renewAccessToken();
        resp = await walletController.changeUser(action, email, walletId);
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await resp).bodyBytes));
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