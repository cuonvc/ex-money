abstract class WalletRepository {
  Future<dynamic> createWallet(String name, String description);
  Future<dynamic> getWalletList();
  Future<dynamic> changeUser(String action, String email, String walletId);
}