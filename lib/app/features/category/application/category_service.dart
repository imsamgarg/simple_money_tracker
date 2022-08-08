import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/category/data/local_category_repository.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

///TODO need to work on this logic
class CategoryService extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final LocalCategoryRepository categoryRepository;

  CategoryService(this.categoryRepository) : super(const AsyncLoading()) {
    //fetch categories on initialization
    getCategories();
  }

  @visibleForTesting
  Future<void> getCategories() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => categoryRepository.getCategories());
  }

  Future<void> addCategory({
    required String name,
    required TransactionType type,
  }) async {
    final model = CategoryModel(categoryName: name, type: type);

    final previousList = state.value!;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final addedModel = await categoryRepository.addCategory(model);
      return previousList..add(addedModel);
    });
  }

  Future<void> deleteCategory(CategoryModel model) async {
    final previousList = state.value!;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await categoryRepository.deleteCategory(model);
      return previousList..removeWhere((e) => e == model);
    });
  }
}

final categoryServiceProvider =
    StateNotifierProvider<CategoryService, AsyncValue<List<CategoryModel>>>(
        (ref) {
  final categoryRepository = ref.watch(localCategoryProvider);
  return CategoryService(categoryRepository);
});
