class ExpenseUpdateRequest {
  late String description;
  late num amount;
  late String entryDate;
  late num categoryId;

  ExpenseUpdateRequest({
    required this.description,
    required this.amount,
    required this.entryDate,
    required this.categoryId,
  });

  static empty() {
    return ExpenseUpdateRequest(
      description: '',
      amount: 0,
      entryDate: '',
      categoryId: 0,
    );
  }

  static Map<String, dynamic> toMap(ExpenseUpdateRequest request) {
    return {
      'description': request.description,
      'amount': request.amount,
      'entryDate': request.entryDate,
      'categoryId': request.categoryId,
    };
  }
}