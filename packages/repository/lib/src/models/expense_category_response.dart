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

  static fromList(List categories) {
    List<ExpenseCategoryResponse> response = [];
    if (categories.isNotEmpty) {
      List<Map<dynamic, dynamic>> categoriesMap = categories.cast<Map<dynamic, dynamic>>();
      for (var itemMap in categoriesMap) {
        response.add(fromMap(itemMap));
      }
    }
    return response;
  }

  static fromMap(Map<dynamic, dynamic> data) {
    List children = data['children'];
    List<ExpenseCategoryResponse> childrenObj = [];
    if (children.isNotEmpty) {
      childrenObj = fromList(children);
    }

    return ExpenseCategoryResponse(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      color: data['color'],
      iconImage: data['iconImage'],
      status: data['status'],
      type: data['type'],
      children: childrenObj,
      refId: data['refId'],
      saveType: data['saveType'],
      createdAt: data['createdAt'],
      createdBy: data['createdBy'],
      updatedAt: data['updatedAt'],
      updatedBy: data['updatedBy'],
    );
  }
}