import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/styles/default_input_border.dart';
import 'package:simple_money_tracker/app/core/utils/date_formats.dart';
import 'package:simple_money_tracker/app/core/widgets/input_prefix_icon.dart';

class DatePickerFormField extends StatefulWidget {
  const DatePickerFormField({
    super.key,
    this.date,
    this.onDateChanged,
    this.validator,
  });

  final DateTime? date;
  final void Function(DateTime? date)? onDateChanged;
  final String? Function(DateTime? date)? validator;
  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  late final TextEditingController controller;
  late DateTime? _date = widget.date;

  late final DateTime _nowTime = DateTime.now();
  late final DateTime _firstDate = (widget.date ?? _nowTime)
      .subtract(const Duration(days: _kMaxEarlierDays));

  static const _kMaxEarlierDays = 60;

  @override
  void initState() {
    controller = TextEditingController(
      text: _date != null ? defaultDateFormat.format(_date!) : null,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      mouseCursor: MaterialStateMouseCursor.clickable,
      onTap: _pickDate,
      validator: (_) => widget.validator?.call(_date),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        hintText: "Select Date",
        filled: true,
        fillColor: Colors.white,
        border: DefaultInputBorder(),
        prefixIcon: InputPrefixIcon(Icons.calendar_today),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedTime = await showDatePicker(
      context: context,
      initialDate: _date ?? _nowTime,
      firstDate: _firstDate,
      lastDate: _nowTime,
    );

    if (pickedTime == null) return;
    _date = pickedTime;
    controller.text = defaultDateFormat.format(pickedTime);
    widget.onDateChanged?.call(pickedTime);
  }
}
