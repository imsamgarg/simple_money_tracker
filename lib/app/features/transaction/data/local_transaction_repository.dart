import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';

abstract class LocalTransactionRepository {
  /// Add Transations
  Future<void> addTransaction(TransactionModel transactionModel);

  /// Delete Transations
  Future<void> deleteTransaction(String id);

  /// Get All Transations
  Future<List<TransactionModel>> getAllTransactions();

  /// Get All Expense
  Future<List<TransactionModel>> getAllExpenses();

  /// Get All Incomes
  Future<List<TransactionModel>> getAllIncomes();
}
