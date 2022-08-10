import 'package:flutter_test/flutter_test.dart';
import 'package:simple_money_tracker/app/features/summary/data/sqlite_summary_repository.dart';
import 'package:simple_money_tracker/app/features/summary/domain/summary_model.dart';
import 'package:simple_money_tracker/app/features/transaction/application/transaction_service.dart';
import 'package:simple_money_tracker/app/features/transaction/data/local_transaction_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/sqlite_transaction_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../helpers/db_helper.dart';
import '../../startup/data/sqlite_startup_repository_test.dart';
import '../../summary/data/sqlite_summary_repository_test.dart';
import '../data/sqlite_transaction_repository_test.dart';

void main() {
  late final TransactionService service;
  late final Database db;
  late final SqliteSummaryRepository summaryRepo;
  late final LocalTransactionRepository txnRepo;

  setUpAll(() async {
    db = await initSqliteInMemoryDb();

    txnRepo = await getTxnTestRepo(db);
    summaryRepo = await getSummaryTestRepo(db);

    final dbRepo = await getDbTestRepo();
    service = TransactionService(dbRepo: dbRepo, txnRepo: txnRepo);
  });

  group('transaction service ...', () {
    test('adding income transaction', () async {
      final initialSummary = await summaryRepo.getSummary();
      final initialTxns = await txnRepo.getAllTransactions();

      ///Should be zero
      expect(initialSummary, SummaryModel());
      expect(initialTxns, <TransactionModel>[]);

      ///Adding transaction                      //defaults to expense
      final txnModel = createTempTransactionModel(TransactionType.income);
      final amount = txnModel.amount;
      await service.addTransaction(
        txnModel,
      );

      final transactions = await txnRepo.getAllTransactions();
      final summary = await summaryRepo.getSummary();

      expect(transactions.length, 1);
      expect(transactions[0].amount, amount);
      expect(summary.totalIncome, amount);
      expect(summary.totalExpenses, 0);
    });
    test('adding expenses transaction', () async {
      final initialSummary = await summaryRepo.getSummary();
      final initialTxns = await txnRepo.getAllTransactions();

      ///Should be zero
      expect(initialSummary, SummaryModel());
      expect(initialTxns, <TransactionModel>[]);

      ///Adding transaction
      final txnModel = createTempTransactionModel();
      final amount = txnModel.amount;
      await service.addTransaction(
        txnModel,
      );

      final transactions = await txnRepo.getAllTransactions();
      final summary = await summaryRepo.getSummary();

      expect(transactions.length, 1);
      expect(transactions[0].amount, amount);
      expect(summary.totalIncome, 0);
      expect(summary.totalExpenses, amount);
    });

    test('deleting transactions', () async {
      final txnModel = createTempTransactionModel();
      final amount = txnModel.amount;
      await service.addTransaction(
        txnModel,
      );

      var transactions = await txnRepo.getAllTransactions();
      var summary = await summaryRepo.getSummary();

      expect(transactions.length, 1);
      expect(transactions[0].amount, amount);
      expect(summary.totalIncome, 0);
      expect(summary.totalExpenses, amount);

      await service.deleteTransaction(txnModel);

      transactions = await txnRepo.getAllTransactions();
      summary = await summaryRepo.getSummary();

      expect(summary, SummaryModel());
      expect(transactions, []);
    });
  });

  tearDown(() async {
    ///Update balance to zero
    await summaryRepo.updateBalance(SummaryModel());
    await db.delete(SqliteTransactionRepository.kTableName);
  });

  tearDownAll(() => db.close());
}
