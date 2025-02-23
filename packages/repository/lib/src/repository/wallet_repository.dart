import 'package:repository/src/models/wallet_setting_request.dart';

abstract class WalletRepository {
  Future<dynamic> createWallet(String name, String description);
  Future<dynamic> deleteWallet(num id);
  Future<dynamic> getWalletList();
  Future<dynamic> changeUser(String action, String email, String walletId);
  Future<dynamic> setting(String walletId, WalletSettingRequest request);
}