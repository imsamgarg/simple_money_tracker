import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/features/summary/data/local_summary_repository.dart';
import 'package:simple_money_tracker/app/features/summary/domain/summary_model.dart';
import 'package:simple_money_tracker/app/features/summary/domain/summary_type.dart';
import 'package:sqflite/sqflite.dart';

class SqliteSummaryRepository extends LocalSummaryRepository {
  final DatabaseExecutor _db;

  SqliteSummaryRepository(this._db);

  static const kSummaryTableName = "summary";
  static final kTableCreateQuery = '''
CREATE TABLE $kSummaryTableName(
  id INTEGER PRIMARY KEY NOT NULL,
  ${SummaryType.totalIncome.value} REAL NOT NULL,
  ${SummaryType.totalExpenes.value} REAL NOT NULL
)
''';

  static final kSummaryInsertQuery = '''
INSERT INTO $kSummaryTableName(${SummaryType.totalIncome.value},${SummaryType.totalExpenes.value}) VALUES(0,0)
 ''';

  @override
  Future<void> addIncome(double amount) {
    return updateBalance(amount, type: SummaryType.totalIncome, op: Op.add);
  }

  @override
  Future<void> addExpenses(double amount) {
    return updateBalance(amount, type: SummaryType.totalExpenes, op: Op.add);
  }

  @override
  Future<void> deductIncome(double amount) {
    return updateBalance(
      amount,
      type: SummaryType.totalIncome,
      op: Op.subtract,
    );
  }

  @override
  Future<void> deductExpenses(double amount) {
    return updateBalance(
      amount,
      type: SummaryType.totalExpenes,
      op: Op.subtract,
    );
  }

  @override
  Future<SummaryModel> getSummary() async {
    final maps = await _db.query(kSummaryTableName);
    return SummaryModel.fromMap(maps[0]);
  }

  ///Expected sanitized values
  @visibleForTesting
  Future<void> updateBalance(
    double amount, {
    required SummaryType type,
    required Op op,
  }) {
    final sign = op == Op.add ? '+' : "-";
    return _db.rawUpdate(
      "UPDATE $kSummaryTableName SET ${type.value} = ${type.value} $sign ?",
      [amount],
    );
  }
}

enum Op { add, subtract }
