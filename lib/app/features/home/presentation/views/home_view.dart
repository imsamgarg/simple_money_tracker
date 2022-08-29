import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_money_tracker/app/features/summary/presentation/widgets/balance_card.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/views/all_expense_transactions.dart';
import 'package:simple_money_tracker/app/routes/app_routes.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding16(
      child: Column(
        children: [
          const BalanceCard(),
          verSpacing28,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Expenses",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).goNamed(AppRoutes.transactions.name);
                },
                child: const Text("View All"),
              ),
            ],
          ),
          verSpacing12,
          const Expanded(child: AllExpenseTransactions()),
        ],
      ),
    );
  }
}
