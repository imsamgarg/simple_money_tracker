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

  List<TransactionModel>? _expenses;
  List<TransactionModel>? _incomes;

  final StreamController<List<TransactionModel>> _expensesStreamController;
  final StreamController<List<TransactionModel>> _incomeStreamController;

  TransactionService({required this.dbRepo, required this.txnRepo})
      : _expensesStreamController = StreamController.broadcast(),
        _incomeStreamController = StreamController.broadcast();

  Future<void> init() async {
    _expensesStreamController.stream.listen((event) => _expenses = event);
    _incomeStreamController.stream.listen((event) => _incomes = event);
  }

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

    late final List<TransactionModel> txns;
    if (isExpense) {
      if (!_expensesStreamController.hasListener) return;

      if (_expenses == null) {
        txns = await watchExpenses.first;
      } else {
        txns = _expenses!;
      }

      return _expensesStreamController.add(txns.toList()..add(txnModel));
    }

    if (!_incomeStreamController.hasListener) return;

    if (_incomes == null) {
      txns = await watchIncomes.first;
    } else {
      txns = _incomes!;
    }
    return _incomeStreamController.add(txns.toList()..add(txnModel));
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
  return service.watchIncomes..listen((event) => service._incomes = event);
});

final expenseTransactionsProvider =
    StreamProvider<List<TransactionModel>>((ref) {
  final service = ref.watch(transactionServiceProvider);
  service
      .getAllExpenses()
      .then((txns) => service._expensesStreamController.add(txns));
  return service.watchExpenses..listen((event) => service._expenses = event);
});
