import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';

class InputPrefixIcon extends StatelessWidget {
  const InputPrefixIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PaddingX12(child: Icon(icon));
  }
}
