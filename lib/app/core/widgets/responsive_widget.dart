import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/utils/size_type.dart';

typedef ResponsiveWidgetBuilder = WidgetBuilder;

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    this.onSmall,
    this.onExtraSmall,
    this.onLarge,
    this.onExtraLarge,
    required this.builder,
  });

  final ResponsiveWidgetBuilder? onSmall;
  final ResponsiveWidgetBuilder? onExtraSmall;
  final ResponsiveWidgetBuilder? onLarge;
  final ResponsiveWidgetBuilder? onExtraLarge;
  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        final width = cons.maxWidth;
        final sizeType = SizeType.fromWidth(width);
        switch (sizeType) {
          case SizeType.extraSmall:
            return onExtraSmall?.call(context) ??
                onSmall?.call(context) ??
                builder(context);
          case SizeType.small:
            return onSmall?.call(context) ?? builder(context);
          case SizeType.medium:
            return builder(context);
          case SizeType.large:
            return onLarge?.call(context) ?? builder(context);
          case SizeType.extraLarge:
            return onExtraLarge?.call(context) ??
                onLarge?.call(context) ??
                builder(context);
        }
      },
    );
  }
}
