import 'package:simple_money_tracker/app/features/transaction/data/local_transaction_batch_op_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/sqlite_transaction_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteTransactionBatchOpRepository
    extends LocalTransactionBatchOpRepository {
  final Batch _batch;

  SqliteTransactionBatchOpRepository(this._batch);
  @override
  void addTransaction(TransactionModel transactionModel) {
    final data = transactionModel.toMap()..remove('category');
    data.putIfAbsent("categoryId", () => transactionModel.category.id);
    data.putIfAbsent(
      "categoryName",
      () => transactionModel.category.categoryName,
    );

    return _batch.insert(SqliteTransactionRepository.kTableName, data);
  }

  @override
  void deleteTransaction(String id) {
    return _batch.delete(
      SqliteTransactionRepository.kTableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
