import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/transactions_list_view.dart';

class AllExpenseTransactionsView extends StatelessWidget {
  const AllExpenseTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    const type = TransactionType.expense;

    return const TransactionsListView(
      key: ValueKey(type),
      type: type,
    );
  }
}
