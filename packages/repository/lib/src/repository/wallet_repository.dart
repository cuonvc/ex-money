abstract class WalletRepository {
  Future<dynamic> getWalletList();
  Future<dynamic> changeUser(String action, String email, String walletId);
}