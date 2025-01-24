class ExpenseCategoryResponse {
  late num id;
  late String name;
  late String description;
  late String? color;
  late String? iconImage;
  late String status;
  late String type;
  late List<ExpenseCategoryResponse> children;
  late num? refId;
  late String? saveType;
  late String createdAt;
  late String createdBy; //tạm thời chưa display
  late String? updatedAt;
  late String? updatedBy; //tạm thời chưa display

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

  static empty() {
    return ExpenseCategoryResponse(
      id: 0,
      name: '',
      description: '',
      color: '',
      iconImage: 'other',
      status: '',
      type: '',
      children: [],
      refId: 0,
      saveType: '',
      createdAt: '',
      createdBy: '',
      updatedAt: '',
      updatedBy: '',
    );
  }

  static listToMap(List<ExpenseCategoryResponse> list) {
    List<Map<String, dynamic>> json = [];
    if (list.isNotEmpty) {
      json = list.map((category) => toMap(category)).toList();
    }
    return json;
  }

  static Map<String, dynamic> toMap(ExpenseCategoryResponse obj) {

    List<ExpenseCategoryResponse> children = obj.children;
    List<Map<String, dynamic>> childrenMapData = [];
    if (children.isNotEmpty) {
      childrenMapData = children.map((child) => toMap(child)).toList();
    }

    return {
      'id': obj.id,
      'name': obj.name,
      'description': obj.description,
      'color': obj.color,
      'iconImage': obj.iconImage,
      'status': obj.status,
      'type': obj.type,
      'children': childrenMapData,
      'refId': obj.refId,
      'saveType': obj.saveType,
      'createdAt': obj.createdAt,
      'createdBy': obj.createdBy,
      'updatedAt': obj.updatedAt,
      'updatedBy': obj.updatedBy,
    };
  }

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
    final children = data['children'];
    List<ExpenseCategoryResponse> childrenObj = [];
    if (children != null && children is List && children.isNotEmpty) {
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