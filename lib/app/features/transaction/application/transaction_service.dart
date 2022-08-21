import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/startup/data/sqlite_database_repository.dart';
import 'package:simple_money_tracker/app/features/summary/data/sqlite_summary_batch_op_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/local_transaction_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/sqlite_transaction_batch_op_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class TransactionService {
  final LocalTransactionRepository txnRepo;
  final SqliteDatabaseRepository dbRepo;

  final StreamController<List<TransactionModel>> _expensesStreamController;
  final StreamController<List<TransactionModel>> _incomeStreamController;

  TransactionService({required this.dbRepo, required this.txnRepo})
      : _expensesStreamController = StreamController.broadcast(),
        _incomeStreamController = StreamController.broadcast();

  Stream<List<TransactionModel>> get watchExpenses =>
      _expensesStreamController.stream;
  Stream<List<TransactionModel>> get watchIncomes =>
      _incomeStreamController.stream;

  /// Add Transations
  Future<void> addTransaction(TransactionModel txnModel) async {
    final batch = dbRepo.batch();
    final transactionBatchRepo = SqliteTransactionBatchOpRepository(batch);
    final summartBatchRepo = SqliteSummaryBatchRepository(batch);

    transactionBatchRepo.addTransaction(txnModel);
    final amount = txnModel.amount;
    final isExpense = txnModel.transactionType == TransactionType.expense;

    if (isExpense) {
      summartBatchRepo.addExpenses(amount);
    } else {
      summartBatchRepo.addIncome(amount);
    }

    await batch.commit();

    if (isExpense) {
      if (!_expensesStreamController.hasListener) return;

      return _expensesStreamController.add(
        (await watchExpenses.last).toList()..add(txnModel),
      );
    }

    if (!_incomeStreamController.hasListener) return;

    return _incomeStreamController.add(
      (await watchIncomes.last).toList()..add(txnModel),
    );
  }

  /// Delete Transations
  Future<void> deleteTransaction(TransactionModel txnModel) {
    final batch = dbRepo.batch();
    final transactionBatchRepo = SqliteTransactionBatchOpRepository(batch);
    final summartBatchRepo = SqliteSummaryBatchRepository(batch);

    transactionBatchRepo.deleteTransaction(txnModel.id);

    if (txnModel.transactionType == TransactionType.expense) {
      summartBatchRepo.deductExpenses(txnModel.amount);
    } else {
      summartBatchRepo.deductIncome(txnModel.amount);
    }

    return batch.commit();
  }

  /// Get All Transations
  Future<List<TransactionModel>> getAllTransactions() =>
      txnRepo.getAllTransactions();

  /// Get All Expense
  Future<List<TransactionModel>> getAllExpenses() => txnRepo.getAllExpenses();

  /// Get All Incomes
  Future<List<TransactionModel>> getAllIncomes() => txnRepo.getAllIncomes();
}

final transactionServiceProvider = Provider<TransactionService>((ref) {
  final localRepo = ref.read(localTransactionProvider);
  final dbRepo = ref.read(sqliteDatabaseProvider);

  return TransactionService(txnRepo: localRepo, dbRepo: dbRepo);
});

final incomeTransactionsProvider =
    StreamProvider<List<TransactionModel>>((ref) {
  final service = ref.watch(transactionServiceProvider);
  service
      .getAllIncomes()
      .then((txns) => service._incomeStreamController.add(txns));
  return service.watchIncomes;
});

final expenseTransactionsProvider =
    StreamProvider<List<TransactionModel>>((ref) {
  final service = ref.watch(transactionServiceProvider);
  service
      .getAllExpenses()
      .then((txns) => service._expensesStreamController.add(txns));
  return service.watchExpenses;
});
