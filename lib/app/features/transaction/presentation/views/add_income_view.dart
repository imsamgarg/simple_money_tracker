import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/core/widgets/date_picker_form_field.dart';
import 'package:simple_money_tracker/app/core/widgets/primary_button.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/category/presentation/widgets/categories_drop_down.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/controllers/add_income_controller.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/widgets/des_text_field.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/widgets/money_text_field.dart';
import 'package:simple_money_tracker/app/features/transaction/presentation/widgets/notes_text_field.dart';

class AddIncomeView extends ConsumerStatefulWidget {
  const AddIncomeView({super.key});

  @override
  _AddIncomeViewState createState() => _AddIncomeViewState();
}

const kInitialAmount = "0";
// final Shader linearGradient = const LinearGradient(
//   colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
// ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

class _AddIncomeViewState extends ConsumerState<AddIncomeView> {
  late final TextEditingController amountController;
  late final TextEditingController desController;
  late final TextEditingController notesController;
  late DateTime? time = DateTime.now();

  CategoryModel? category;

  late final GlobalKey<FormState> _formKey = GlobalKey();

  static const _defaultSpacing = verSpacing20;

  @override
  void initState() {
    amountController = TextEditingController(text: kInitialAmount);
    desController = TextEditingController();
    notesController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    desController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addIncomeController.notifier);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "Add Income",
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 0.8,
              wordSpacing: 0.1,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          verSpacing32,
          Padding(
            padding: px16,
            child: AmountTextField(
              controller: amountController,
              validator: controller.amountValidator,
            ),
          ),
          verSpacing28,
          CategoriesDropdownButtonFormField(
            validator: controller.categoryValidator,
            onChanged: (category) => this.category = category,
          ),
          _defaultSpacing,
          NotesTextField(
            controller: notesController,
            validator: controller.notesValidator,
          ),
          _defaultSpacing,
          DescriptionTextField(
            controller: desController,
            validator: controller.descriptionValidator,
          ),
          _defaultSpacing,
          DatePickerFormField(
            date: time,
            validator: controller.dateValidator,
            onDateChanged: (d) => time = d,
          ),
          const Spacer(),
          Consumer(
            builder: (_, ref, ___) {
              final state = ref.watch(addIncomeController);
              return FullWidthBox(
                child: PrimaryButton(
                  onPressed: () => _addIncome(controller),
                  isLoading: state.isLoading,
                  child: const Text("Save"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addIncome(AddIncomeController controller) async {
    if (!_formKey.currentState!.validate()) return;

    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Categories not loaded")),
      );
      return;
    }

    await controller.addIncome(
      time: time!,
      amount: double.parse(amountController.text),
      category: category!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaction Saved")),
    );
  }
}
