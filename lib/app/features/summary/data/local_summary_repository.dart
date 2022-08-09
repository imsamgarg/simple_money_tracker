import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/summary/domain/summary_model.dart';

abstract class LocalSummaryRepository {
  Future<SummaryModel> getSummary();
  Future<void> addIncome(double amount);
  Future<void> deductIncome(double amount);
  Future<void> deductExpenses(double amount);
  Future<void> addExpenses(double amount);
}

final localSummaryProvider = Provider<LocalSummaryRepository>((_) {
  throw UnimplementedError();
});
