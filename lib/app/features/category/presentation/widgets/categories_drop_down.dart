import 'package:custom_utils/spacing_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/core/constants/sizes.dart';
import 'package:simple_money_tracker/app/core/styles/default_input_border.dart';
import 'package:simple_money_tracker/app/core/widgets/input_prefix_icon.dart';
import 'package:simple_money_tracker/app/features/category/application/category_service.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';

class CategoriesDropdownButtonFormField extends ConsumerWidget {
  const CategoriesDropdownButtonFormField({
    this.validator,
    required this.onChanged,
    super.key,
  });

  final ValueChanged<CategoryModel?> onChanged;
  final FormFieldValidator<CategoryModel>? validator;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryServiceProvider);

    return Container(
      height: 55,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: kTextFieldDefaultBorderRadius,
      ),
      child: categories.map(
        data: (data) {
          return ClipRRect(
            borderRadius: kTextFieldDefaultBorderRadius,
            child: Material(
              color: Colors.transparent,
              child: DropdownButtonFormField<CategoryModel>(
                elevation: 1,
                validator: validator,
                hint: const Text("Select Category"),
                selectedItemBuilder: (_) => _selectedItemBuilder(data.value),
                focusColor: Colors.transparent,
                itemHeight: 65,
                borderRadius: kTextFieldDefaultBorderRadius,
                decoration: const InputDecoration(
                  prefixIcon: InputPrefixIcon(Icons.category_rounded),
                  border: DefaultInputBorder(),
                ),
                items: data.value.map(_buildDropdownMenuItem).toList(),
                onChanged: onChanged,
              ),
            ),
          );
        },
        error: (_) => const Text("Failed to fetch categories"),
        loading: (_) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  List<Widget> _selectedItemBuilder(List<CategoryModel> categories) {
    return categories.map((e) => Text(e.categoryName)).toList();
  }

  DropdownMenuItem<CategoryModel> _buildDropdownMenuItem(CategoryModel e) {
    return DropdownMenuItem<CategoryModel>(
      value: e,
      child: Row(
        children: [
          if (e.imagePath == null)
            const Icon(Icons.settings)
          else
            Image.asset(
              e.imagePath!,
              height: 24,
              width: 24,
            ),
          horSpacing16,
          Text(e.categoryName)
        ],
      ),
    );
  }
}
