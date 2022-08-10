import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/core/utils/unique_id_generator.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/application/transaction_service.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class AddIncomeController extends StateNotifier<AsyncValue<void>> {
  final TransactionService service;

  AddIncomeController(this.service) : super(const AsyncData(null));

  Future<void> addExpense({
    required double amount,
    required CategoryModel category,
  }) async {
    state = const AsyncLoading();
    final txnModel = createTxnModel(amount: amount, category: category);
    state = await AsyncValue.guard(
      () => service.addTransaction(txnModel),
    );
  }

  @visibleForTesting
  TransactionModel createTxnModel({
    required double amount,
    required CategoryModel category,
    //For testing
    DateTime? time,
  }) {
    final txnTime = time ?? DateTime.now();
    final id = getUniqueId(time: txnTime);
    return TransactionModel(
      transactionType: TransactionType.income,
      amount: amount,
      time: txnTime,
      id: id,
      category: category,
    );
  }
}

final addIncomeController =
    StateNotifierProvider.autoDispose<AddIncomeController, AsyncValue<void>>(
        (ref) {
  final service = ref.watch(transactionServiceProvider);
  return AddIncomeController(service);
});
