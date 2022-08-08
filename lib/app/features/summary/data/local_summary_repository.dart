import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/summary/domain/summary_model.dart';

mixin DatabaseReadSummmary {
  Future<SummaryModel> getSummary();
  Future<double> getBalance() async => (await getSummary()).balance;
}
mixin DatabaseWriteSummary {
  void addIncome(double amount);
  void deductIncome(double amount);
  void deductExpenses(double amount);
  void addExpenses(double amount);
}

abstract class LocalSummaryRepository
    with DatabaseWriteSummary, DatabaseReadSummmary {}

final localSummaryProvider = Provider<LocalSummaryRepository>((_) {
  throw UnimplementedError();
});
