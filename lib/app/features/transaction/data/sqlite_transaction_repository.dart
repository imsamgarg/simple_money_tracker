import 'package:simple_money_tracker/app/features/category/data/sqlite_category_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/data/local_transaction_repository.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';
import 'package:sqflite/sqflite.dart';

class SqliteTransactionRepository extends LocalTransactionRepository {
  final Database _db;

  SqliteTransactionRepository(this._db);
  static const kTableName = "transactions";
  static const kTableCreateQuery = '''
CREATE TABLE $kTableName(
  id TEXT PRIMARY KEY NOT NULL,
  time NUMBER NOT NULL,
  notes TEXT,
  description TEXT,
  categoryId NUMBER NOT NULL,
  categoryName TEXT NOT NULL,
  amount REAL NOT NULL,
  transactionType TEXT NOT NULL,
  FOREIGN KEY (categoryId) REFERENCES ${SqliteCategoryRepository.kCategoryTableName}(id)
);
''';

  @override
  Future<void> addTransaction(TransactionModel transactionModel) {
    final data = transactionModel.toMap()..remove('category');
    data.putIfAbsent("categoryId", () => transactionModel.category.id);
    data.putIfAbsent(
      "categoryName",
      () => transactionModel.category.categoryName,
    );

    return _db.insert(kTableName, data);
  }

  @override
  Future<void> deleteTransaction(String id) {
    return _db.delete(kTableName, where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<List<TransactionModel>> getAllExpenses() {
    return _getTransactionsByType(TransactionType.expense);
  }

  Future<List<TransactionModel>> _getTransactionsByType(
    TransactionType type,
  ) async {
    final maps = await _db.query(
      kTableName,
      where: "transactionType = ?",
      whereArgs: [type.value],
    );

    return maps.map(_transactionModelConverter).toList();
  }

  TransactionModel _transactionModelConverter(Map<String, Object?> data) {
    final category = {
      "categoryName": data['categoryName'],
      "type": data['transactionType'],
      "id": data["categoryId"]
    };

    final newData = {...category, ...data};
    newData.putIfAbsent("category", () => category);
    return TransactionModel.fromMap(newData);
  }

  @override
  Future<List<TransactionModel>> getAllIncomes() {
    return _getTransactionsByType(TransactionType.income);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final maps = await _db.query(kTableName);

    return maps.map(_transactionModelConverter).toList();
  }
}
