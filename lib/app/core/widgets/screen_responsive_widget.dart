import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/utils/device_screen_type.dart';

typedef ScreenResposiveWidgetBuilder = WidgetBuilder;

class ScreenResponsiveWidget extends StatefulWidget {
  const ScreenResponsiveWidget({
    super.key,
    required this.builder,
    this.onDesktop,
    this.onTablet,
  });

  final ScreenResposiveWidgetBuilder builder;
  final ScreenResposiveWidgetBuilder? onDesktop;
  final ScreenResposiveWidgetBuilder? onTablet;

  @override
  State<ScreenResponsiveWidget> createState() => _ScreenResponsiveWidgetState();
}

class _ScreenResponsiveWidgetState extends State<ScreenResponsiveWidget> {
  late DeviceScreenType deviceScreenType;

  @override
  void didChangeDependencies() {
    final width = MediaQuery.of(context).size.width;
    deviceScreenType = DeviceScreenType.fromWidth(width);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    switch (deviceScreenType) {
      case DeviceScreenType.desktop:
        return widget.onDesktop?.call(context) ?? widget.builder(context);
      case DeviceScreenType.tablet:
        return widget.onTablet?.call(context) ?? widget.builder(context);
      case DeviceScreenType.mobile:
        return widget.builder(context);
    }
  }
}
