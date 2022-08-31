import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/transactions_view.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: TransactionsView(),
      ),
    );
  }
}
