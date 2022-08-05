import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_money_tracker/app/core/utils/unique_id_generator.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/data/local_transaction_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';

class TransactionService {
  final LocalTransactionRepository localRepo;

  TransactionService({required this.localRepo});

  /// Add Transations
  Future<void> addTransaction({
    required double amount,
    required TransactionType transactionType,
    required CategoryModel category,
  }) {
    final time = DateTime.now();
    final id = getUniqueId();
    final txnModel = TransactionModel(
      transactionType: transactionType,
      amount: amount,
      time: time,
      id: id,
      category: category,
    );
    return localRepo.addTransaction(txnModel);
  }

  /// Delete Transations
  Future<void> deleteTransaction(String id) => localRepo.deleteTransaction(id);

  /// Get All Transations
  Future<List<TransactionModel>> getAllTransactions() =>
      localRepo.getAllTransactions();

  /// Get All Expense
  Future<List<TransactionModel>> getAllExpenses() => localRepo.getAllExpenses();

  /// Get All Incomes
  Future<List<TransactionModel>> getAllIncomes() => localRepo.getAllIncomes();
}

final transactionServiceProvider = Provider<TransactionService>((ref) {
  final localRepo = ref.read(localTransactionProvider);
  return TransactionService(localRepo: localRepo);
});
