class ExpenseFilterResource {
  late num walletId;
  late String walletName;
  late List<Map<dynamic, dynamic>> otherWalletMap;
  late List<Map<dynamic, dynamic>> categories;
  late List<Map<dynamic, dynamic>> members;

  ExpenseFilterResource({
    required this.walletId,
    required this.walletName,
    required this.otherWalletMap,
    required this.categories,
    required this.members
  });

  static ExpenseFilterResource fromMap(Map<dynamic, dynamic> data) {
    List otherWallets = data['otherWalletMap'];
    List categories = data['categories'];
    List members = data['members'];
    List<Map<dynamic, dynamic>> walletListOfMap = otherWallets.toList().cast<Map<dynamic, dynamic>>();
    List<Map<dynamic, dynamic>> categoryListOfMap = categories.toList().cast<Map<dynamic, dynamic>>();
    List<Map<dynamic, dynamic>> memberListOfMap = members.toList().cast<Map<dynamic, dynamic>>();

    return ExpenseFilterResource(
      walletId: data['walletId'],
      walletName: data['walletName'],
      otherWalletMap: walletListOfMap,
      categories: categoryListOfMap,
      members: memberListOfMap
    );
  }
}