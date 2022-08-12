import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

abstract class LocalCategoryRepository {
  ///Delete Category
  Future<void> deleteCategory(CategoryModel categoryModel);

  ///Add Category
  Future<CategoryModel> addCategory(CategoryModel categoryModel);

  ///Get all the user created categories
  Future<List<CategoryModel>> getCategories();

  ///Might not be needed
  ///Get categories by type
  Future<List<CategoryModel>> getCategoriesByType(TransactionType type);
}

final localCategoryProvider = Provider<LocalCategoryRepository>((_) {
  throw UnimplementedError();
});
