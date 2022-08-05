import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

final builtInCategories = <CategoryModel>[
  const CategoryModel(categoryName: "Food", type: TransactionType.expense),
];
