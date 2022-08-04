import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/app.dart';
import 'package:simple_money_tracker/app/core/constants/strings.dart';
import 'package:simple_money_tracker/app/features/category/data/local_category_repository.dart';
import 'package:simple_money_tracker/app/features/category/data/sqlite_category_repository.dart';
import 'package:simple_money_tracker/app/features/startup/data/sqlite_startup_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/local_transaction_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/sqlite_transaction_repository.dart';

void main() async {
  const sqliteRepo = SqliteStartupRepository(
    kDbName,
    //For creating tables on first start
    queriesOnDatabaseCreation: [
      SqliteCategoryRepository.kTableCreateQuery,
      SqliteTransactionRepository.kTableCreateQuery
    ],
  );

  ///Init database
  final database = await sqliteRepo.initialize();

  final localCategoryRepository = SqliteCategoryRepository(database);
  final localTransactionRepository = SqliteTransactionRepository(database);

  final container = ProviderContainer(
    overrides: [
      localCategoryProvider.overrideWithValue(localCategoryRepository),
      localTransactionProvider.overrideWithValue(localTransactionRepository),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}
