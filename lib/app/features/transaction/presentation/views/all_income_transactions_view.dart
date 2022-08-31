import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/transactions_list_view.dart';

class AllIncomeTransactionsView extends StatelessWidget {
  const AllIncomeTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    const type = TransactionType.income;

    return const TransactionsListView(
      key: ValueKey(type),
      type: type,
    );
  }
}
