import 'package:custom_utils/padding.dart';
import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/theme/app_theme.dart';
import 'package:simple_money_tracker/app/features/home/presentation/views/home_view.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/add_expense_view.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/add_income_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: Row(
        children: const [
          Expanded(child: Scaffold(body: HomeView())),
          Expanded(
            child: Scaffold(
              body: Padding32(
                child: AddIncomeView(),
              ),
            ),
          ),
          Expanded(
            child: ScaffoldMessenger(
              child: Scaffold(
                body: Padding32(
                  child: AddExpenseView(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
