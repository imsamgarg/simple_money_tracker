import 'package:simple_money_tracker/app/features/category/data/local_category_repository.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteCategoryRepository implements LocalCategoryRepository {
  final Database _db;

  SqliteCategoryRepository(this._db);

  static const kCategoryTableName = "categories";
  static const kTableCreateQuery = '''
CREATE TABLE $kCategoryTableName(
  categoryName TEXT NOT NULL UNIQUE,
  imagePath TEXT
)
''';

  @override
  Future<CategoryModel> addCategory(String categoryName) async {
    final categoryModel = CategoryModel(categoryName: categoryName);

    await _db.insert(
      kCategoryTableName,
      categoryModel.toMap(),
    );

    return categoryModel;
  }

  @override
  Future<void> deleteCategory(String categoryName) async {
    await _db.delete(
      kCategoryTableName,
      where: "categoryName = ?",
      whereArgs: [categoryName],
    );
  }

  @override
  Future<List<CategoryModel>> getUserCreatedCategories() async {
    final maps = await _db.query(kCategoryTableName);
    return maps.map((e) => CategoryModel.fromMap(e)).toList();
  }
}
