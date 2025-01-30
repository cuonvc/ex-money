import 'dart:core';

import 'package:repository/src/models/expense_scheduler_response.dart';

import '../../repository.dart';

class WalletResponse {
  late num id;
  late String status;
  late num ownerUserId;
  late List<UserResponse> members;
  late List<ExpenseSchedulerResponse> schedulers;
  late String name;
  late String? description;
  late num totalIncome;
  late num totalExpense;
  late num balance;
  late num? expenseLimit;
  late num? expenseWarningLevel1;
  late num? expenseWarningLevel2;
  late num? expenseWarningLevel3;
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
    required this.schedulers,
    required this.name,
    required this.description,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.expenseLimit,
    required this.expenseWarningLevel1,
    required this.expenseWarningLevel2,
    required this.expenseWarningLevel3,
    required this.expenses,
    required this.otherWallets,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  static WalletResponse fromMap(Map<String, dynamic> map) {

    var membersVal = map['members'];
    var expensesVal = map['expenses'];
    var schedulersVal = map['schedulers'];

    List<ExpenseResponse> expenses = [];
    List<UserResponse> members = [];
    List<ExpenseSchedulerResponse> schedulers = [];
    if (expensesVal != null) {
      List rawExpenses = expensesVal;
      expenses = rawExpenses.map((expense) => ExpenseResponse.fromMap(expense)).toList();
    }
    if (membersVal != null) {
      List rawMembers = membersVal;
      members = rawMembers.map((user) => UserResponse.fromMap(user)).toList();
    }

    if(schedulersVal != null) {
      List rawSchedulers = schedulersVal;
      schedulers = rawSchedulers.map((element) => ExpenseSchedulerResponse.fromMap(element)).toList();
    }

    return WalletResponse(
      id: map['id'],
      status: map['status'],
      ownerUserId: map['ownerUserId'],
      members: members,
      schedulers: schedulers,
      name: map['name'],
      description: map['description'],
      totalIncome: map['totalIncome'],
      totalExpense: map['totalExpense'],
      balance: map['balance'],
      expenseLimit: map['expenseLimit'],
      expenseWarningLevel1: map['expenseWarningLevel1'],
      expenseWarningLevel2: map['expenseWarningLevel2'],
      expenseWarningLevel3: map['expenseWarningLevel3'],
      expenses: expenses,
      otherWallets: null,
      isDefault: map['isDefault'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      createdBy: map['createdBy'],
      updatedBy: map['updatedBy'],
    );
  }

  static WalletResponse empty() {
    return WalletResponse(
      id: 0,
      status: '',
      ownerUserId: 0,
      members: [],
      schedulers: [],
      name: '',
      description: '',
      totalIncome: 0,
      totalExpense: 0,
      balance: 0,
      expenseLimit: null,
      expenseWarningLevel1: null,
      expenseWarningLevel2: null,
      expenseWarningLevel3: null,
      expenses: [],
      otherWallets: null,
      isDefault: false,
      createdAt: '',
      updatedAt: '',
      createdBy: 0,
      updatedBy: 0,
    );
  }
}