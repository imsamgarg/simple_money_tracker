import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/category/application/category_service.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class AddCategoryController extends StateNotifier<AsyncValue<void>> {
  AddCategoryController(this.categoryService) : super(const AsyncData(null));

  final CategoryService categoryService;

  Future<void> addCategory({
    required String name,
    required TransactionType type,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => categoryService.addCategory(name: name, type: type),
    );
  }
}

final addCategoryController = StateNotifierProvider.autoDispose
    .family<AddCategoryController, AsyncValue<void>, TransactionType>(
        (ref, type) {
  final categoryService = ref.watch(categoryServiceProvider(type).notifier);
  return AddCategoryController(categoryService);
});
