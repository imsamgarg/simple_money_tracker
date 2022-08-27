import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/app.dart';
import 'package:simple_money_tracker/app/core/constants/built_in_categories.dart';
import 'package:simple_money_tracker/app/features/category/data/local_category_repository.dart';
import 'package:simple_money_tracker/app/features/category/data/sqlite_category_repository.dart';
import 'package:simple_money_tracker/app/features/startup/data/sqlite_database_repository.dart';
import 'package:simple_money_tracker/app/features/summary/data/local_summary_repository.dart';
import 'package:simple_money_tracker/app/features/summary/data/sqlite_summary_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/local_transaction_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/sqlite_transaction_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  runApp(const Center(child: CircularProgressIndicator()));

  final sqliteRepo = SqliteDatabaseRepository(
    inMemoryDatabasePath,
    dbFactory: databaseFactoryFfi,
    //For creating tables on first start
    queriesOnDatabaseCreation: [
      SqliteTransactionRepository.kTableCreateQuery,
      SqliteCategoryRepository.kTableCreateQuery,
      SqliteSummaryRepository.kTableCreateQuery,

      //For creating built in categories to database
      SqliteCategoryRepository.createMultipleInsertQuery(builtInCategories),
      //For creating 1 row of summary
      SqliteSummaryRepository.kSummaryInsertQuery,
    ],
  );

  ///Init database
  final database = await sqliteRepo.initialize();

  final localCategoryRepository = SqliteCategoryRepository(database);
  final localTransactionRepository = SqliteTransactionRepository(database);
  final localSummaryRepository = SqliteSummaryRepository(database);

  final container = ProviderContainer(
    overrides: [
      sqliteDatabaseProvider.overrideWithValue(sqliteRepo),
      localCategoryProvider.overrideWithValue(localCategoryRepository),
      localTransactionProvider.overrideWithValue(localTransactionRepository),
      localSummaryProvider.overrideWithValue(localSummaryRepository),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}
