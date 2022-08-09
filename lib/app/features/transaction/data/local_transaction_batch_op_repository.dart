import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';

abstract class LocalTransactionBatchOpRepository {
  /// Add Transations
  void addTransaction(TransactionModel transactionModel);

  /// Delete Transations
  void deleteTransaction(String id);
}
