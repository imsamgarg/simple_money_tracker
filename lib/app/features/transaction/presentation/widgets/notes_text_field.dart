import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/styles/default_input_border.dart';
import 'package:simple_money_tracker/app/core/widgets/input_prefix_icon.dart';

class NotesTextField extends StatelessWidget {
  const NotesTextField({
    super.key,
    required this.controller,
    this.validator,
  });

  final FormFieldValidator<String>? validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: const InputDecoration(
        hintText: "Notes",
        filled: true,
        fillColor: Colors.white,
        border: DefaultInputBorder(),
        prefixIcon: InputPrefixIcon(Icons.note),
      ),
    );
  }
}
