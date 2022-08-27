import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';

mixin TransactionValidator {
  String? descriptionValidator(String? v) {
    return null;
  }

  String? notesValidator(String? v) {
    return null;
  }

  String? amountValidator(String? v) {
    final String? value = v;

    if (value == null) return "Please Enter Amount";

    final double? amount = double.tryParse(value);

    if (amount == null) return "Please enter valid amount";
    if (amount == 0) return "Amount must be greater than 0";

    return null;
  }

  String? categoryValidator(CategoryModel? category) {
    if (category == null) return "Please Select Category";
    return null;
  }

  String? dateValidator(DateTime? date) {
    if (date == null) return "Please Select Date";
    return null;
  }
}
