import '../../repository.dart';

//data for expense edit screen
class ExpenseEditResource {
  late num walletId;
  late String walletName;
  late List<Map<dynamic, dynamic>> otherWalletMap;
  late List categories;

  ExpenseEditResource({
    required this.walletId,
    required this.walletName,
    required this.otherWalletMap,
    required this.categories,
  });

  static ExpenseEditResource fromMap(Map<dynamic, dynamic> data) {
    List otherWallets = data['otherWalletMap'];
    List<Map<dynamic, dynamic>> listOfMap = otherWallets.toList().cast<Map<dynamic, dynamic>>();

    // List<ExpenseCategoryResponse> categories = ExpenseCategoryResponse.fromMap(data['categories'][0]);

    return ExpenseEditResource(
      walletId: data['walletId'],
      walletName: data['walletName'],
      otherWalletMap: listOfMap,
      categories: data['categories'],
    );
  }

  static Map<String, dynamic> toMap(ExpenseEditResource data) {
    return {
      'walletId': data.walletId,
      'walletName': data.walletName,
      'otherWalletMap': data.otherWalletMap,
      'categories': data.categories,
    };
  }
}