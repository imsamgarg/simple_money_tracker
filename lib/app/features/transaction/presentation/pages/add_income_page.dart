import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/add_income_view.dart';

class AddIncomePage extends StatelessWidget {
  const AddIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AddIncomeView(),
    );
  }
}