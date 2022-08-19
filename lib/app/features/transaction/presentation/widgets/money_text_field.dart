import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/constants/sizes.dart';
import 'package:simple_money_tracker/app/core/extensions/color_extensions.dart';
import 'package:simple_money_tracker/app/core/utils/text_formatters.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({
    super.key,
    required this.controller,
    this.validator,
  });
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [MoneyInputFormatter()],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      keyboardType: TextInputType.number,
      autofocus: true,
      cursorHeight: 5,
      cursorWidth: 03,
      cursorRadius: const Radius.circular(50),
      style: TextStyle(
        fontSize: 28,
        color: context.primaryColor,
      ),
      controller: controller,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        filled: true,
        contentPadding: py24,
        fillColor: Colors.white,
        hoverColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(rc24),
        ),
      ),
    );
  }
}
