import 'package:flutter/foundation.dart';
import 'package:simple_money_tracker/app/features/summary/data/local_summary_repository.dart';
import 'package:simple_money_tracker/app/features/summary/data/sqlite_summary_repository.dart';
import 'package:simple_money_tracker/app/features/summary/domain/summary_type.dart';
import 'package:sqflite/sqflite.dart';

class SqliteSummaryBatchRepository with DatabaseWriteSummary {
  final Batch _batch;

  SqliteSummaryBatchRepository(this._batch);

  @override
  void addIncome(double amount) {
    return updateBalance(amount, type: SummaryType.totalIncome, op: Op.add);
  }

  @override
  void addExpenses(double amount) {
    return updateBalance(amount, type: SummaryType.totalExpenes, op: Op.add);
  }

  @override
  void deductIncome(double amount) {
    return updateBalance(
      amount,
      type: SummaryType.totalIncome,
      op: Op.subtract,
    );
  }

  @override
  void deductExpenses(double amount) {
    return updateBalance(
      amount,
      type: SummaryType.totalExpenes,
      op: Op.subtract,
    );
  }

  @visibleForTesting
  void updateBalance(
    double amount, {
    required SummaryType type,
    required Op op,
  }) {
    final sign = op == Op.add ? '+' : "-";
    return _batch.rawUpdate(
      "UPDATE ${SqliteSummaryRepository.kSummaryTableName} SET ${type.value} = ${type.value} $sign ?",
      [amount],
    );
  }
}
