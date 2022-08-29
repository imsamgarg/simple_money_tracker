import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/core/constants/sizes.dart';
import 'package:simple_money_tracker/app/core/widgets/responsive_widget.dart';
import 'package:simple_money_tracker/app/features/summary/application/summary_service.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({this.padding = p16, super.key});

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(balanceProvider);
    return state.map(
      data: (d) => _BalanceCard(
        key: UniqueKey(),
        padding: padding,
        totalBalance: "${d.value.totalExpenses + d.value.totalIncome}",
        totalIncome: "${d.value.totalIncome}",
        totalExpenses: "${d.value.totalExpenses}",
      ),
      error: (_) => _BalanceCard(
        key: UniqueKey(),
        padding: padding,
        totalBalance: "Error..",
        totalIncome: "...",
        totalExpenses: "...",
      ),
      loading: (_) => _BalanceCard(
        key: UniqueKey(),
        padding: padding,
        totalBalance: "Loading..",
        totalIncome: "...",
        totalExpenses: "...",
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    super.key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.padding,
  });

  final String totalBalance;
  final String totalIncome;
  final String totalExpenses;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final incomeSection = _buildIncomeSection();
    final expenseSection = _buildExpenseSection();
    final balance = _buildBalance(theme);
    final title = _buildTotalBalanceTitle();

    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Container(
        margin: p16,
        padding: padding,
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: const BorderRadius.all(kDefaultRadius),
        ),
        child: ResponsiveWidget(
          builder: (context) {
            return Column(
              children: [
                title,
                verSpacing8,
                balance,
                verSpacing16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [incomeSection, expenseSection],
                ),
              ],
            );
          },
          onExtraSmall: (context) {
            return Center(
              child: Column(
                children: [
                  title,
                  verSpacing8,
                  balance,
                  verSpacing16,
                  incomeSection,
                  verSpacing16,
                  expenseSection
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Text _buildTotalBalanceTitle() {
    return const Text(
      "Total Balance",
      style: TextStyle(
        fontSize: 13,
      ),
    );
  }

  Text _buildBalance(ThemeData theme) {
    return Text(
      totalBalance,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: theme.textTheme.headlineSmall!.fontSize,
      ),
    );
  }

  _Subsection _buildIncomeSection() {
    return _Subsection(
      amount: totalIncome,
      icon: const Icon(Icons.arrow_upward_rounded, color: Colors.green),
      title: "Income    ",
    );
  }

  _Subsection _buildExpenseSection() {
    return _Subsection(
      amount: totalExpenses,
      icon: const Icon(Icons.arrow_downward_rounded, color: Colors.red),
      title: "Expenses",
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
      mainAxisAlignment: MainAxisAlignment.center,
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
