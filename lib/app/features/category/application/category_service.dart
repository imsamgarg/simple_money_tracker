import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/core/constants/built_in_categories.dart';
import 'package:simple_money_tracker/app/features/category/data/local_category_repository.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class CategoryService {
  late final _categoriesController = StreamController<List<CategoryModel>>();

  late final _categoriesStream = _categoriesController.stream;

  final LocalCategoryRepository categoryRepository;

  late final List<CategoryModel> _categories = builtInCategories;
  CategoryService(this.categoryRepository);

  Stream<List<CategoryModel>> _getCatgories() {
    categoryRepository.getUserCreatedCategories().then((categories) {
      _categories.addAll(categories);
      _categoriesController.add(categories);
    });
    return _categoriesStream;
  }

  Future<void> addCategory({
    required String name,
    required TransactionType type,
  }) async {
    final model = CategoryModel(categoryName: name, type: type);
    final modelFromDatabase = await categoryRepository.addCategory(model);
    _categories.add(modelFromDatabase);
    _categoriesController.add(_categories);
  }

  Future<void> deleteCategory(CategoryModel model) async {
    await categoryRepository.deleteCategory(model);
    _categories.removeWhere((e) => e == model);
    _categoriesController.add(_categories);
  }
}

final categoryServiceProvider = Provider<CategoryService>((ref) {
  final categoryRepository = ref.watch(localCategoryProvider);
  return CategoryService(categoryRepository);
});

final categoriesStreamProvider = StreamProvider((ref) {
  return ref.watch(categoryServiceProvider)._getCatgories();
});
