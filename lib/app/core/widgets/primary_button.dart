import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/constants/sizes.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
  });
  final VoidCallback onPressed;
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: p24,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(kButtonDefaultRadius),
        ),
      ),
      onPressed: onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : child,
    );
  }
}
