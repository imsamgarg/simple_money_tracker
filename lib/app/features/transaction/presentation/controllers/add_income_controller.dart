import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/application/transaction_service.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class AddIncomeController extends StateNotifier<AsyncValue<void>> {
  final TransactionService service;

  AddIncomeController(this.service) : super(const AsyncData(null));

  Future<void> addExpense({
    required double amount,
    required CategoryModel category,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => service.addTransaction(
        amount: amount,
        transactionType: TransactionType.income,
        category: category,
      ),
    );
  }
}

final addIncomeController =
    StateNotifierProvider.autoDispose<AddIncomeController, AsyncValue<void>>(
        (ref) {
  final service = ref.watch(transactionServiceProvider);
  return AddIncomeController(service);
});
