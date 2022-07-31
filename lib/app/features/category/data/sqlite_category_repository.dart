import 'package:simple_money_tracker/app/features/category/data/local_category_repository.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteCategoryRepository implements LocalCategoryRepository {
  final Database _db;

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

  @override
  Future<CategoryModel> addCategory(CategoryModel categoryModel) async {
    await _db.insert(
      kCategoryTableName,
      categoryModel.toMap(),
    );

    return categoryModel;
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
  Future<List<CategoryModel>> getUserCreatedCategories() async {
    final maps = await _db.query(kCategoryTableName);
    return maps.map((e) => CategoryModel.fromMap(e)).toList();
  }
}
