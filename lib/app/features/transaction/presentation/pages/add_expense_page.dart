import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/add_expense_view.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding16(
        child: AddExpenseView(),
      ),
    );
  }
}
