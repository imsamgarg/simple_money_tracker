import 'package:flutter_test/flutter_test.dart';
import 'package:simple_money_tracker/app/core/constants/built_in_categories.dart';
import 'package:simple_money_tracker/app/features/category/data/sqlite_category_repository.dart';
import 'package:simple_money_tracker/app/features/startup/data/sqlite_database_repository.dart';
import 'package:simple_money_tracker/app/features/summary/data/sqlite_summary_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/sqlite_transaction_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../category/data/sqlite_category_repository_test.dart';
import '../../transaction/data/sqlite_transaction_repository_test.dart';

Future<SqliteDatabaseRepository> getDbTestRepo() async {
  final repo = SqliteDatabaseRepository(
    inMemoryDatabasePath,
    dbFactory: databaseFactoryFfi,
    queriesOnDatabaseCreation: [],
  );

  ///There must be no errors
  await repo.initialize();
  return repo;
}

void main() {
  setUpAll(() => sqfliteFfiInit());
  late Database db;

  group('sqlte startup repo test', () {
    test('initializing', () async {
      final repo = SqliteDatabaseRepository(
        inMemoryDatabasePath,
        dbFactory: databaseFactoryFfi,
        queriesOnDatabaseCreation: [],
      );

      ///There must be no errors
      db = await repo.initialize();
    });

    test('create real app queries', () async {
      final repo = SqliteDatabaseRepository(
        inMemoryDatabasePath,
        dbFactory: databaseFactoryFfi,
        queriesOnDatabaseCreation: [
          SqliteCategoryRepository.kTableCreateQuery,
          SqliteTransactionRepository.kTableCreateQuery,
          SqliteSummaryRepository.kTableCreateQuery,

          //For creating built in categories to database
          SqliteCategoryRepository.createMultipleInsertQuery(builtInCategories),
          //For creating 1 row of summary
          SqliteSummaryRepository.kSummaryInsertQuery,
        ],
      );

      db = await repo.initialize();
      final catRepo = SqliteCategoryRepository(db);
      final transactionRepo = SqliteTransactionRepository(db);
      final summaryRepo = SqliteSummaryRepository(db);

      await summaryRepo.getSummary();
      var categories = await catRepo.getCategories();
      var transactions = await transactionRepo.getAllTransactions();

      ///Because table is empty
      expect(categories.isEmpty, false);
      expect(transactions.isEmpty, true);

      ///Try Adding some values
      final categoryModel = createTempCategoryModel("food");
      await catRepo.addCategory(categoryModel);
      final transactionModel = createTempTransactionModel();
      await transactionRepo.addTransaction(transactionModel);

      categories = await catRepo.getCategories();
      transactions = await transactionRepo.getAllTransactions();

      expect(categories.length, 9);
      expect(transactions.length, 1);

      expect(categories.last, categoryModel);
      expect(transactions[0], transactionModel);
    });
    test('without create table queries', () async {
      final repo = SqliteDatabaseRepository(
        inMemoryDatabasePath,
        dbFactory: databaseFactoryFfi,
        queriesOnDatabaseCreation: [],
      );

      db = await repo.initialize();
      final catRepo = SqliteCategoryRepository(db);
      final transactionRepo = SqliteTransactionRepository(db);

      ///Must throw exception because no tables have created
      expect(
        () => catRepo.getCategories(),
        throwsA(isA<DatabaseException>()),
      );
      expect(
        () => transactionRepo.getAllTransactions(),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  tearDown(() => db.close());
}
