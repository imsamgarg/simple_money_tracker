import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_money_tracker/app/features/home/presentation/pages/home_page.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/pages/add_expense_page.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/pages/add_income_page.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/pages/transactions_page.dart';
import 'package:simple_money_tracker/app/routes/app_routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home.path,
    routes: [
      GoRoute(
        path: AppRoutes.home.path,
        name: AppRoutes.home.name,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: AppRoutes.addExpense.path,
            name: AppRoutes.addExpense.name,
            builder: (context, state) => const AddExpensePage(),
          ),
          GoRoute(
            path: AppRoutes.addIncome.path,
            name: AppRoutes.addIncome.name,
            builder: (context, state) => const AddIncomePage(),
          ),
          GoRoute(
            path: AppRoutes.transactions.path,
            name: AppRoutes.transactions.name,
            builder: (context, state) => const TransactionsPage(),
          )
        ],
      ),
    ],
  );
});
