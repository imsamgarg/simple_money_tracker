import 'package:flutter/services.dart';

class MoneyInputFormatter extends FilteringTextInputFormatter {
  MoneyInputFormatter()
      : super(
          RegExp(r'(^\d+\.{0,1}\d{0,2})'),
          allow: true,
          replacementString: "",
        );
}
