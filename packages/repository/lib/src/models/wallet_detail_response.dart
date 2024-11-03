import 'package:repository/repository.dart';

class WalletDetailResponse {
  String id;
  String status;
  String ownerUserId;
  String name;
  String? description;
  num totalIncome;
  num totalExpense;
  num balance;
  List<ExpenseResponse> expenses;
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
      isDefault: data['isDefault'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
}