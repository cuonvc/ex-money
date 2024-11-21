import 'package:repository/repository.dart';

class WalletDetailResponse {
  num id;
  String status;
  num ownerUserId;
  String name;
  String? description;
  num totalIncome;
  num totalExpense;
  num balance;
  List<ExpenseResponse> expenses;
  List<Map<dynamic, dynamic>> otherWalletMap;
  bool isDefault;
  String createdAt;
  String? updatedAt;

  WalletDetailResponse({
    required this.id,
    required this.status,
    required this.ownerUserId,
    required this.name,
    required this.description,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.expenses,
    required this.otherWalletMap,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  static WalletDetailResponse fromMap(Map<String, dynamic> data) {
    List expenses = data['expenses'];
    List<ExpenseResponse> responseList = expenses
        .map((e) => ExpenseResponse.fromMap(e))
        .toList()
        .cast<ExpenseResponse>();

    List otherWallets = data['otherWallets'];
    List<Map<dynamic, dynamic>> listOfMap = otherWallets.toList().cast<Map<dynamic, dynamic>>();

    return WalletDetailResponse(
      id: data['id'],
      status: data['status'],
      ownerUserId: data['ownerUserId'],
      name: data['name'],
      description: data['description'],
      totalIncome: data['totalIncome'],
      totalExpense: data['totalExpense'],
      balance: data['balance'],
      expenses: responseList,
      otherWalletMap: listOfMap,
      isDefault: data['isDefault'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
}