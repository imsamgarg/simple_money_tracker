import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

final builtInCategories = <CategoryModel>[
  const CategoryModel(
    id: 1,
    categoryName: "Food",
    type: TransactionType.expense,
  ),
  const CategoryModel(
    id: 2,
    categoryName: "Rent",
    type: TransactionType.expense,
  ),
  const CategoryModel(
    id: 3,
    categoryName: "Travel",
    type: TransactionType.expense,
  ),
  const CategoryModel(
    id: 4,
    categoryName: "Shopping",
    type: TransactionType.expense,
  ),
  const CategoryModel(
    id: 5,
    categoryName: "Salary",
    type: TransactionType.income,
  ),
  const CategoryModel(
    id: 6,
    categoryName: "Gift",
    type: TransactionType.income,
  ),
  const CategoryModel(
    id: 7,
    categoryName: "Others",
    type: TransactionType.income,
  ),
  const CategoryModel(
    id: 8,
    categoryName: "Others",
    type: TransactionType.expense,
  ),
];
