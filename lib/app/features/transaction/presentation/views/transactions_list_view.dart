import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/features/transaction/application/transaction_service.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/widgets/transaction_tile.dart';

class TransactionsListView extends ConsumerWidget {
  const TransactionsListView({required this.type, super.key});

  final TransactionType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      type == TransactionType.expense
          ? expenseTransactionsProvider
          : incomeTransactionsProvider,
    );

    return state.map(
      data: (data) {
        final transactions = data.value.reversed.toList();
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.separated(
            itemCount: transactions.length,
            itemBuilder: (BuildContext context, int index) {
              final txn = transactions[index];
              return TransactionTile(transaction: txn);
            },
            separatorBuilder: (BuildContext context, int index) {
              return verSpacing12;
            },
          ),
        );
      },
      error: (error) => const Center(child: Text("Failed to fetch incomes")),
      loading: (loading) => const Center(child: CircularProgressIndicator()),
    );
  }
}
