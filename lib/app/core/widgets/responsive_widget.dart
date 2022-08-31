import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/utils/size_type.dart';

typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  SizeType sizeType,
);

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.builder,
  });

  final ResponsiveWidgetBuilder builder;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        final width = cons.maxWidth;
        final sizeType = SizeType.fromWidth(width);
        return builder(context, sizeType);
      },
    );
  }
}
