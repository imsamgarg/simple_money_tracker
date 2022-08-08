import 'package:simple_money_tracker/app/features/category/data/local_category_repository.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteCategoryRepository implements LocalCategoryRepository {
  /// *Uses [DatabaseExecutor] so that same class can be used for sqlite transaction
  final DatabaseExecutor _db;

  SqliteCategoryRepository(this._db);

  static const kCategoryTableName = "categories";
  static const kTableCreateQuery = '''
CREATE TABLE $kCategoryTableName(
  id INTEGER PRIMARY KEY NOT NULL,
  categoryName TEXT NOT NULL,
  imagePath TEXT,
  type TEXT NOT NULL
)
''';

  static const _kCategoryInsertQuery = '''
INSERT INTO $kCategoryTableName(id,categoryName,imagePath,type)
 ''';
  @override
  Future<CategoryModel> addCategory(CategoryModel categoryModel) async {
    final id = await _db.insert(
      kCategoryTableName,
      categoryModel.toMap(),
    );

    return categoryModel.copyWith(id: id);
  }

  ///TODO: can be implemented but not needed
  // Future<void> addAllCategories(List<CategoryModel> categoryModels) async {}

  ///*Used for storing categories at first start time
  ///
  ///Didn't used simple insert as it would create some overhead.
  static String createMultipleInsertQuery(List<CategoryModel> categoryModels) {
    final buffer = StringBuffer(_kCategoryInsertQuery);

    buffer.write("VALUES");
    for (int i = 0; i < categoryModels.length; i++) {
      final model = categoryModels[i];

      buffer
        ..write("(")
        ..write(model.id)
        ..write(",")
        ..write(model.categoryName)
        ..write(",")
        ..write(model.imagePath)
        ..write(",")
        ..write(model.type.value)
        ..write(")");

      if (i != categoryModels.length - 1) buffer.writeln(",");
    }

    buffer.writeln(";");
    return buffer.toString();
  }

  @override
  Future<void> deleteCategory(CategoryModel categoryModel) {
    return _db.delete(
      kCategoryTableName,
      where: "id = ?",
      whereArgs: [categoryModel.id],
    );
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final maps = await _db.query(kCategoryTableName);
    return maps.map((e) => CategoryModel.fromMap(e)).toList();
  }
}
