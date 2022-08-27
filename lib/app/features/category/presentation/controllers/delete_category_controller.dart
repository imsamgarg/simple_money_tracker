import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/category/application/category_service.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';

class DeleteCategoryController extends StateNotifier<AsyncValue<void>> {
  DeleteCategoryController(this.categoryService, {required this.categoryModel})
      : super(const AsyncData(null));

  final CategoryService categoryService;
  final CategoryModel categoryModel;

  Future<void> deleteCategory() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => categoryService.deleteCategory(categoryModel),
    );
  }
}

final deleteCategoryController = StateNotifierProvider.autoDispose
    .family<DeleteCategoryController, AsyncValue<void>, CategoryModel>(
        (ref, model) {
  final categoryService =
      ref.watch(categoryServiceProvider(model.type).notifier);
  return DeleteCategoryController(
    categoryService,
    categoryModel: model,
  );
});
