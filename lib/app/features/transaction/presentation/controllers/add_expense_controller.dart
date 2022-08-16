import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/core/utils/unique_id_generator.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/application/transaction_service.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/controllers/transaction_validators.dart';

class AddExpenseController extends StateNotifier<AsyncValue<void>>
    with TransactionValidator {
  final TransactionService _service;

  AddExpenseController(this._service) : super(const AsyncData(null));

  Future<void> addExpense({
    required double amount,
    required CategoryModel category,
    required DateTime time,
    String? description,
    String? notes,
  }) async {
    state = const AsyncLoading();
    final id = getUniqueId();
    final txnModel = TransactionModel(
      amount: amount,
      time: time,
      category: category,
      description: description,
      notes: notes,
      id: id,
      transactionType: TransactionType.expense,
    );
    state = await AsyncValue.guard(
      () => _service.addTransaction(txnModel),
    );
  }
}

final addExpenseController =
    StateNotifierProvider.autoDispose<AddExpenseController, AsyncValue<void>>(
        (ref) {
  final service = ref.watch(transactionServiceProvider);
  return AddExpenseController(service);
});
