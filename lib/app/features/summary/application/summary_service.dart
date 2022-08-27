import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/summary/data/local_summary_repository.dart';
import 'package:simple_money_tracker/app/features/summary/domain/summary_model.dart';
import 'package:simple_money_tracker/app/features/transaction/application/transaction_service.dart';

final balanceProvider = FutureProvider<SummaryModel>((ref) async {
  ref
    ..watch(incomeTransactionsProvider)
    ..watch(expenseTransactionsProvider);

  final repo = ref.watch(localSummaryProvider);

  return repo.getSummary();
});
