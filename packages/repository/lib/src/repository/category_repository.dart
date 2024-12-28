import 'package:repository/repository.dart';

abstract class CategoryRepository {
  Future<dynamic> getCategoryList(num? walletId);
  Future<dynamic> saveCategory(num? id, ExpenseCategoryRequest request);
}