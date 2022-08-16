import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/constants/sizes.dart';

class DefaultInputBorder extends OutlineInputBorder {
  const DefaultInputBorder()
      : super(
          borderRadius: const BorderRadius.all(kTextFieldDefaultRadius),
          borderSide: BorderSide.none,
        );
}
