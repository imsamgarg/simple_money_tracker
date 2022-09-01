import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_money_tracker/app/routes/app_routes.dart';

class AddTransactionFAB extends StatefulWidget {
  const AddTransactionFAB();

  @override
  State<AddTransactionFAB> createState() => _AddTransactionFABState();
}

const double buttonSize = 54;

class _AddTransactionFABState extends State<AddTransactionFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Flow(
          clipBehavior: Clip.none,
          delegate: _AddTransactionFlowDelegate(controller),
          children: [
            _AddExpenseFab(animation: animation),
            _AddIncomeFab(animation: animation),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: SizedBox.square(
            dimension: buttonSize,
            child: FloatingActionButton(
              heroTag: "add_transaction",
              onPressed: _controlAnimation,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.625).animate(animation),
                child: const Icon(
                  Icons.add,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _controlAnimation() {
    if (controller.status == AnimationStatus.completed) {
      controller.reverse();
      return;
    }
    controller.forward();
  }
}

class _AddExpenseFab extends StatelessWidget {
  const _AddExpenseFab({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: buttonSize,
      child: FadeTransition(
        opacity: animation,
        child: FloatingActionButton(
          heroTag: "add_expense",
          onPressed: () {
            GoRouter.of(context).goNamed(AppRoutes.addExpense.name);
          },
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.arrow_downward_rounded,
            size: 28,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

class _AddIncomeFab extends StatelessWidget {
  const _AddIncomeFab({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: buttonSize,
      child: FadeTransition(
        opacity: animation,
        child: FloatingActionButton(
          heroTag: "add_income",
          backgroundColor: Colors.white,
          onPressed: () {
            GoRouter.of(context).goNamed(AppRoutes.addIncome.name);
          },
          child: const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.green,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _AddTransactionFlowDelegate extends FlowDelegate {
  final Animation<double> animation;

  _AddTransactionFlowDelegate(this.animation) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;

    if (animation.isDismissed) {
      return;
    }
    for (int i = 0; i < context.childCount; i++) {
      const gap = 68;
      final offset = (i + 1) * gap * animation.value;
      final y = size.height - buttonSize - offset;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          size.width - buttonSize,
          y,
          0,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_AddTransactionFlowDelegate oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
