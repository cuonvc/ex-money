class ExpenseCategoryRequest {
  late String name;
  late String description;
  late String iconImage;
  late num? parentId;
  late String? saveType;
  late num? refId;

  ExpenseCategoryRequest({
    required this.name,
    required this.description,
    required this.iconImage,
    required this.parentId,
    required this.saveType,
    required this.refId,
  });

  static Map<String, dynamic> toMap(ExpenseCategoryRequest request) {
    Map<String, dynamic> map = {
      "name": request.name,
      "description": request.description,
      "iconImage": request.iconImage,
      "parentId": request.parentId,
      "saveType": request.saveType,
      "refId": request.refId
    };
    return map;
  }
}