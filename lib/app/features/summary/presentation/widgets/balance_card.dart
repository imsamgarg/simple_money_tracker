import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/core/constants/sizes.dart';
import 'package:simple_money_tracker/app/features/summary/application/summary_service.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(balanceProvider);
    return state.map(
      data: (d) => _BalanceCard(
        key: UniqueKey(),
        totalBalance: "${d.value.totalExpenses + d.value.totalIncome}",
        totalIncome: "${d.value.totalIncome}",
        totalExpenses: "${d.value.totalExpenses}",
      ),
      error: (_) => _BalanceCard(
        key: UniqueKey(),
        totalBalance: "Error..",
        totalIncome: "...",
        totalExpenses: "...",
      ),
      loading: (_) => _BalanceCard(
        key: UniqueKey(),
        totalBalance: "Loading..",
        totalIncome: "...",
        totalExpenses: "...",
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    super.key,
  });

  final String totalBalance;
  final String totalIncome;
  final String totalExpenses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: p16,
      padding: p16,
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: const BorderRadius.all(kDefaultRadius),
      ),
      child: Column(
        children: [
          const Text("Total Balance"),
          Text(
            totalBalance,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: theme.textTheme.headlineSmall!.fontSize,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(totalIncome),
              Text(totalExpenses),
            ],
          ),
        ],
      ),
    );
  }
}
