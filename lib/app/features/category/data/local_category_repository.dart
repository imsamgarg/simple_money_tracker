import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';

abstract class LocalCategoryRepository {
  ///Delete Category
  Future<void> deleteCategory(CategoryModel categoryModel);

  ///Add Category
  Future<CategoryModel> addCategory(CategoryModel categoryModel);

  ///Get all the user created categories
  Future<List<CategoryModel>> getUserCreatedCategories();
}
