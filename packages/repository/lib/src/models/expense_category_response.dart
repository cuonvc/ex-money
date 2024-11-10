class ExpenseCategoryResponse {
  late String id;
  late String name;
  late String description;
  late String? color;
  late String? iconImage;
  late String status;
  late String type;
  late List<ExpenseCategoryResponse> children;
  late String refId;
  late String saveType;
  late String createdAt;
  late String createdBy;
  late String? updatedAt;
  late String? updatedBy;

  ExpenseCategoryResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.iconImage,
    required this.status,
    required this.type,
    required this.children,
    required this.refId,
    required this.saveType,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  static fromMap(Map<String, dynamic> data) {
    List children = data['children'];
    // if (children.isNotEmpty) {
    //   for (final c in children) {
    //     List<ExpenseCategoryResponse> children = ExpenseCategoryResponse.fromMap(c);
    //   }
    //
    // }

    return ExpenseCategoryResponse(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      color: data['color'],
      iconImage: data['iconImage'],
      status: data['status'],
      type: data['type'],
      children: [],
      refId: data['refId'],
      saveType: data['saveType'],
      createdAt: data['createdAt'],
      createdBy: data['createdBy'],
      updatedAt: data['updatedAt'],
      updatedBy: data['updatedBy'],
    );
  }
}