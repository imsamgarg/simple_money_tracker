// ignore_for_file: public_member_api_docs, sort_constructors_first
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

    return Builder(
      builder: (context) {
        return DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Container(
            margin: p16,
            padding: p16,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              // gradient: LinearGradient(
              //   colors: [
              //     theme.primaryColor,
              //   ],
              // ),
              borderRadius: const BorderRadius.all(kDefaultRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Total Balance",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
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
                    _Subsection(
                      amount: totalIncome,
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.green,
                      ),
                      title: "Income",
                    ),
                    _Subsection(
                      amount: totalExpenses,
                      icon: const Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.red,
                      ),
                      title: "Expenses",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Subsection extends StatelessWidget {
  const _Subsection({
    super.key,
    required this.title,
    required this.icon,
    required this.amount,
  });

  final String title;
  final Icon icon;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Padding4(
            child: icon,
          ),
        ),
        horSpacing12,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
