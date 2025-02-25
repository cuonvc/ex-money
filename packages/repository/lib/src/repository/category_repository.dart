import 'package:repository/repository.dart';

abstract class CategoryRepository {
  Future<dynamic> getCategoryList(num? walletId, String keyword);
  Future<dynamic> saveCategory(num? id, ExpenseCategoryRequest request);
  Future<dynamic> deleteById(num id);
}