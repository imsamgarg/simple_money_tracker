import 'package:custom_utils/custom_utils.dart';
import 'package:flutter/material.dart';
import 'package:simple_money_tracker/app/core/constants/sizes.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
  });

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final image = transaction.category.imagePath;
    return ListTile(
      tileColor: Colors.white,
      contentPadding: p12,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(kDefaultRadius),
      ),
      title: Text(transaction.category.categoryName),
      trailing: Text("${transaction.amount}"),
      leading: image != null ? Image.asset(image) : const Icon(Icons.settings),
    );
  }
}
