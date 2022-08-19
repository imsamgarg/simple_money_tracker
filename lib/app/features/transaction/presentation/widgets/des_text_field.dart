import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/styles/default_input_border.dart';
import 'package:simple_money_tracker/app/core/widgets/input_prefix_icon.dart';

class DescriptionTextField extends StatelessWidget {
  const DescriptionTextField({
    super.key,
    required this.controller,
    this.validator,
  });

  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: const InputDecoration(
        hintText: "Description",
        filled: true,
        fillColor: Colors.white,
        border: DefaultInputBorder(),
        // prefix: Icon(Icons.edit),
        prefixIcon: InputPrefixIcon(Icons.edit),
      ),
    );
  }
}
