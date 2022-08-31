import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/widgets/screen_responsive_widget.dart';
import 'package:simple_money_tracker/app/features/home/presentation/views/home_view.dart';
import 'package:simple_money_tracker/app/features/home/presentation/widgets/add_transaction_fab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenResponsiveWidget(
      builder: (context, screenType) {
        return const SafeArea(
          child: Scaffold(
            body: HomeView(),
            floatingActionButton: AddTransactionFAB(),
          ),
        );
      },
    );
  }
}
