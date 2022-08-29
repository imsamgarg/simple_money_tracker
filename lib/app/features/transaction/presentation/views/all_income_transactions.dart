import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/transaction/application/transaction_service.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/widgets/transaction_tile.dart';

class AllIncomeTransactions extends ConsumerWidget {
  const AllIncomeTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(incomeTransactionsProvider);
    return state.map(
      data: (data) {
        final transactions = data.value.reversed.toList();
        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (BuildContext context, int index) {
            final txn = transactions[index];
            return TransactionTile(transaction: txn);
          },
        );
      },
      error: (error) => const Center(child: Text("Failed to fetch incomes")),
      loading: (loading) => const Center(child: CircularProgressIndicator()),
    );
  }
}