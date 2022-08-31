import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_money_tracker/app/core/widgets/screen_responsive_widget.dart';
import 'package:simple_money_tracker/app/features/home/presentation/views/home_view.dart';
import 'package:simple_money_tracker/app/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenResponsiveWidget(
      builder: (context, screenType) {
        return SafeArea(
          child: Scaffold(
            body: const HomeView(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                GoRouter.of(context).goNamed(AppRoutes.addExpense.name);
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
