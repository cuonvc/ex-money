import 'dart:core';

import '../../repository.dart';

class WalletResponse {
  late num id;
  late String status;
  late num ownerUserId;
  late List<String> members;
  late String name;
  late String? description;
  late num totalIncome;
  late num totalExpense;
  late num balance;
  late List<ExpenseResponse> expenses;
  late List? otherWallets;
  late bool isDefault;
  late String createdAt;
  late String? updatedAt;
  late num createdBy;
  late num? updatedBy;

  WalletResponse({
    required this.id,
    required this.status,
    required this.ownerUserId,
    required this.members,
    required this.name,
    required this.description,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.expenses,
    required this.otherWallets,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  static WalletResponse fromMap(Map<String, dynamic> map) {

    List rawMembers = map['members'];
    List rawExpenses = map['expenses'];
    List<ExpenseResponse> expenses = rawExpenses.map((expense) => ExpenseResponse.fromMap(expense)).toList();
    List<String> members = rawMembers.toList().cast<String>();

    return WalletResponse(
      id: map['id'],
      status: map['status'],
      ownerUserId: map['ownerUserId'],
      members: members,
      name: map['name'],
      description: map['description'],
      totalIncome: map['totalIncome'],
      totalExpense: map['totalExpense'],
      balance: map['balance'],
      expenses: expenses,
      otherWallets: null,
      isDefault: map['isDefault'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
    );
  }
}