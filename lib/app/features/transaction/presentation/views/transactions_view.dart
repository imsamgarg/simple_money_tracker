import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/extensions/color_extensions.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/all_expense_transactions_view.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/all_income_transactions_view.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  @override
  Widget build(BuildContext context) {
    const incomesWidget = AllIncomeTransactionsView();
    const expensesWidget = AllExpenseTransactionsView();

    return Padding16(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: TabBar(
                labelColor: context.primaryColor,
                tabs: const [
                  Tab(
                    text: "Incomes",
                  ),
                  Tab(
                    text: "Expenses",
                  ),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  incomesWidget,
                  expensesWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
