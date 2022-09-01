import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/core/constants/sizes.dart';
import 'package:simple_money_tracker/app/core/styles/default_input_border.dart';
import 'package:simple_money_tracker/app/core/widgets/input_prefix_icon.dart';
import 'package:simple_money_tracker/app/features/category/application/category_service.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class CategoriesDropdownButtonFormField extends ConsumerWidget {
  const CategoriesDropdownButtonFormField({
    required this.onChanged,
    required this.transactionType,
    this.validator,
  });

  final ValueChanged<CategoryModel?> onChanged;
  final TransactionType transactionType;
  final FormFieldValidator<CategoryModel>? validator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryServiceProvider(transactionType));

    return categories.map(
      data: (data) {
        final categories = data.value;
        return Theme(
          data: Theme.of(context).copyWith(
            hoverColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            focusColor: Colors.white,
          ),
          child: DropdownButtonFormField<CategoryModel>(
            elevation: 1,
            validator: validator,
            hint: const Text("Select Category"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            selectedItemBuilder: (_) => _selectedItemBuilder(categories),
            focusColor: Colors.transparent,
            itemHeight: 65,
            borderRadius: kTextFieldDefaultBorderRadius,
            decoration: const InputDecoration(
              prefixIcon: InputPrefixIcon(Icons.category_rounded),
              border: DefaultInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            items: categories.map(_buildDropdownMenuItem).toList(),
            onChanged: onChanged,
          ),
        );
      },
      error: (_) => const _ErrorWidget(),
      loading: (_) => const _LoadingWidget(),
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

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: kTextFieldDefaultBorderRadius,
      ),
      child: const FullWidthBox(
        child: Align(
          alignment: Alignment.centerLeft,
          child: PaddingX16(
            child: Text("Loading Categories ...."),
          ),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    return const TextField(
      enabled: true,
      readOnly: true,
      decoration: InputDecoration(
        border: DefaultInputBorder(),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: InputPrefixIcon(Icons.category),
        hintText: "Error in fetching categories",
      ),
    );
  }
}
