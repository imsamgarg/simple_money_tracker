import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/add_income_view.dart';

class AddIncomePage extends StatelessWidget {
  const AddIncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Padding16(
          child: AddIncomeView(),
        ),
      ),
    );
  }
}
