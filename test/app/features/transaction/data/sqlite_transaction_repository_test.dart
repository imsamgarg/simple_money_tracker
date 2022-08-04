import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_money_tracker/app/core/utils/unique_id_generator.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/data/sqlite_transaction_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

TransactionModel createTempTransactionModel([TransactionType? type]) {
  return TransactionModel(
    transactionType: type ?? TransactionType.expense,
    amount: Random().nextDouble() * 99,
    time: DateTime(2017),
    id: getUniqueId(),
    category: CategoryModel(
      id: Random().nextInt(99999),
      categoryName: "food",
      type: type ?? TransactionType.expense,
    ),
  );
}

void main() {
  const table = SqliteTransactionRepository.kTableName;
  Future<void> _cleanUp(Database db) async => db.delete(table);

  late final Database db;
  late final SqliteTransactionRepository repo;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    db = await openDatabase(inMemoryDatabasePath);
    repo = SqliteTransactionRepository(db);
    await db.execute(SqliteTransactionRepository.kTableCreateQuery);
  });

  group('sqlite transaction repo test group ', () {
    test('add transaction', () async {
      final model = createTempTransactionModel();
      await repo.addTransaction(model);

      final newModels = await repo.getAllTransactions();
      expect(newModels.length, 1);
      expect(newModels[0], model);
      const counter = 5;
      for (var i = 0; i < counter; i++) {
        await repo.addTransaction(createTempTransactionModel());
      }

      final models = await repo.getAllTransactions();
      expect(models.length, counter + 1);

      ///For duplication
      expect(
        () => repo.addTransaction(model),
        throwsA(isA<DatabaseException>()),
      );
    });
    test('delete transaction', () async {
      final model = createTempTransactionModel();

      await repo.addTransaction(model);
      var dbModels = await repo.getAllTransactions();
      expect(dbModels.length, 1);
      expect(dbModels[0], model);

      /// Try Deleting
      await repo.deleteTransaction(model.id);
      dbModels = await repo.getAllTransactions();
      expect(dbModels.length, 0);

      const count = 5;
      final models = List.generate(count, (_) => createTempTransactionModel());

      for (final model in models) {
        await repo.addTransaction(model);
      }
      const index = 3;

      ///Deleting model index:3
      await repo.deleteTransaction(models[index].id);
      dbModels = await repo.getAllTransactions();
      expect(dbModels.length, count - 1);
      expect(dbModels.contains(models[index]), false);

      for (var i = 0; i < count; i++) {
        if (i == index) continue;
        expect(dbModels.contains(models[i]), true);
      }
    });
    test('get expenses and income', () async {
      const count = 5;

      ///default to expenses
      final models = List.generate(count, (_) => createTempTransactionModel());

      for (final model in models) {
        await repo.addTransaction(model);
      }

      var dbModels = await repo.getAllTransactions();
      expect(dbModels.length, count);

      ///default to expenses
      dbModels = await repo.getAllExpenses();
      expect(dbModels.length, count);

      dbModels = await repo.getAllIncomes();
      expect(dbModels.length, 0);

      final incomes = List.generate(
        count,
        (_) => createTempTransactionModel(TransactionType.income),
      );

      for (final income in incomes) {
        await repo.addTransaction(income);
      }

      dbModels = await repo.getAllExpenses();
      expect(dbModels.length, count);

      dbModels = await repo.getAllIncomes();
      expect(dbModels.length, count);

      dbModels = await repo.getAllTransactions();
      expect(dbModels.length, count * 2);
    });
  });

  tearDownAll(() => db.close());
  tearDown(() => _cleanUp(db));
}
