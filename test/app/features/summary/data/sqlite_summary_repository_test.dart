import 'package:flutter_test/flutter_test.dart';
import 'package:simple_money_tracker/app/features/summary/data/sqlite_summary_repository.dart';
import 'package:simple_money_tracker/app/features/summary/domain/summary_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../helpers/db_helper.dart';

SummaryModel get createBalanceModel {
  return SummaryModel(totalIncome: 12.00, totalExpenses: 12.00);
}

Future<SqliteSummaryRepository> getSummaryTestRepo(Database db) async {
  await db.execute(SqliteSummaryRepository.kTableCreateQuery);
  await db.execute(SqliteSummaryRepository.kSummaryInsertQuery);
  return SqliteSummaryRepository(db);
}

void main() {
  late final Database db;
  late final SqliteSummaryRepository repo;

  setUpAll(() async {
    db = await initSqliteInMemoryDb();
    repo = await getSummaryTestRepo(db);
  });
  group('sqlite summary repository', () {
    test("checking initial income n expenses to be 0", () async {
      final summary = await repo.getSummary();

      expect(summary.totalExpenses, 0);
      expect(summary.balance, 0);
      expect(summary.totalIncome, 0);
    });
    test('checking adding expenses', () async {
      const double expenseAmount = 100;
      SummaryModel summary;

      await repo.addExpenses(expenseAmount);
      summary = await repo.getSummary();

      expect(summary.totalExpenses, expenseAmount);
      expect(summary.totalIncome, 0);

      await repo.addExpenses(expenseAmount);
      summary = await repo.getSummary();

      expect(summary.totalExpenses, expenseAmount + expenseAmount);
      expect(summary.totalIncome, 0);
    });

    test('checking adding income', () async {
      const double incomeAmount = 100;
      SummaryModel summary;

      await repo.addIncome(incomeAmount);
      summary = await repo.getSummary();

      expect(summary.totalIncome, incomeAmount);
      expect(summary.totalExpenses, 0);

      await repo.addIncome(incomeAmount);
      summary = await repo.getSummary();

      expect(summary.totalIncome, incomeAmount + incomeAmount);
      expect(summary.totalExpenses, 0);
    });
    test('checking adding income and then deducting', () async {
      SummaryModel summary;
      const double incomeAmount = 100;

      await repo.addIncome(incomeAmount);
      summary = await repo.getSummary();

      expect(summary.totalIncome, incomeAmount);
      expect(summary.totalExpenses, 0);

      await repo.deductIncome(incomeAmount);
      summary = await repo.getSummary();

      expect(summary.totalIncome, 0);
      expect(summary.totalExpenses, 0);
    });

    test('checking adding expenses and then deducting', () async {
      const double expenseAmount = 100;
      SummaryModel summary;

      await repo.addExpenses(expenseAmount);
      summary = await repo.getSummary();

      expect(summary.totalExpenses, expenseAmount);
      expect(summary.totalIncome, 0);

      await repo.deductExpenses(expenseAmount);
      summary = await repo.getSummary();

      expect(summary.totalExpenses, 0);
      expect(summary.totalIncome, 0);
    });

    tearDown(() async {
      await repo.updateBalance(SummaryModel());
    });
  });

  tearDownAll(() => db.close());
}
