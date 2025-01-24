class WalletSettingRequest {
  late num? totalExpenseLimit;
  late num? expenseWarningLevel1;
  late num? expenseWarningLevel2;
  late num? expenseWarningLevel3;

  WalletSettingRequest({
    required this.totalExpenseLimit,
    required this.expenseWarningLevel1,
    required this.expenseWarningLevel2,
    required this.expenseWarningLevel3,
  });

  static Map<String, dynamic> toMap(WalletSettingRequest data) {
    return {
      "totalExpenseLimit": data.totalExpenseLimit,
      "expenseWarningLevel1": data.expenseWarningLevel1,
      "expenseWarningLevel2": data.expenseWarningLevel2,
      "expenseWarningLevel3": data.expenseWarningLevel3,
    };
  }

  static WalletSettingRequest fromMap(Map<String, dynamic> data) {
    return WalletSettingRequest(
      totalExpenseLimit: data['totalExpenseLimit'],
      expenseWarningLevel1: data['expenseWarningLevel1'],
      expenseWarningLevel2: data['expenseWarningLevel2'],
      expenseWarningLevel3: data['expenseWarningLevel3'],
    );
  }
}