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
  Widget build(BuildContext context) {
    final elevation = Theme.of(context).floatingActionButtonTheme.elevation;
    return Flow(
      delegate: _AddTransactionFlowDelegate(controller),
      children: [
        SizedBox.square(
          dimension: buttonSize,
          child: FadeTransition(
            opacity: animation,
            child: FloatingActionButton(
              elevation: elevation,
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
        ),
        SizedBox.square(
          dimension: buttonSize,
          child: FadeTransition(
            opacity: animation,
            child: FloatingActionButton(
              elevation: elevation,
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
        ),
        SizedBox.square(
          dimension: buttonSize,
          child: FloatingActionButton(
            onPressed: () {
              if (controller.status == AnimationStatus.completed) {
                controller.reverse();
                return;
              }
              controller.forward();
            },
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.625).animate(animation),
              child: const Icon(
                Icons.add,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddTransactionFlowDelegate extends FlowDelegate {
  final Animation<double> animation;

  _AddTransactionFlowDelegate(this.animation) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    const xPadding = 32;
    const yPadding = 16;
    if (animation.isDismissed) {
      return context.paintChild(
        context.childCount - 1,
        transform: Matrix4.translationValues(
          size.width - buttonSize - xPadding,
          size.height - yPadding - buttonSize,
          0,
        ),
      );
    }
    for (int i = 0; i < context.childCount - 1; i++) {
      const gap = 68;
      final offset = (i + 1) * gap * animation.value;
      final y = size.height - buttonSize - yPadding - offset;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          size.width - buttonSize - xPadding,
          y,
          0,
        ),
      );
    }

    context.paintChild(
      context.childCount - 1,
      transform: Matrix4.translationValues(
        size.width - buttonSize - xPadding,
        size.height - yPadding - buttonSize,
        0,
      ),
    );
  }

  @override
  bool shouldRepaint(_AddTransactionFlowDelegate oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
