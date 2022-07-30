import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_money_tracker/app/features/category/data/sqlite_category_repository.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> _cleanUp(Database db) async => db.delete(_table);

const _table = SqliteCategoryRepository.kCategoryTableName;

void main() {
  late final Database db;
  late final SqliteCategoryRepository repo;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    db = await openDatabase(inMemoryDatabasePath);
    repo = SqliteCategoryRepository(db);
    await db.execute(SqliteCategoryRepository.kTableCreateQuery);
  });

  group('sqlite category repository test group', () {
    test("add categories", () async {
      await repo.addCategory("food");

      var data = await db.query(_table);
      expect(data.length, 1);

      final model = CategoryModel.fromMap(data[0]);

      expect(model.categoryName, "food");
      expect(model.imagePath, null);

      await _cleanUp(db);
      for (var i = 0; i < 5; i++) {
        await repo.addCategory("food$i");
      }

      data = await db.query(_table);
      expect(data.length, 5);

      ///Throws Exception on duplicate category name
      expect(
        () => repo.addCategory("food1"),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('delete categories', () async {
      await repo.addCategory("food");

      var data = await db.query(_table);
      expect(data.length, 1);

      await repo.deleteCategory("food");
      data = await db.query(_table);
      expect(data.length, 0);

      for (var i = 0; i < 5; i++) {
        await repo.addCategory("food$i");
      }
      data = await db.query(_table);
      expect(data.length, 5);

      await repo.deleteCategory("food1");
      await repo.deleteCategory("food2");

      data = await db.query(_table);
      expect(data.length, 3);

      final models = data.map((e) => CategoryModel.fromMap(e)).toList();

      expect(models.where((e) => e.categoryName == "food1").length, 0);
      expect(models.where((e) => e.categoryName == "food2").length, 0);
    });
    test('get all categories', () async {
      final models = <CategoryModel>[];

      for (var i = 0; i < 5; i++) {
        models.add(CategoryModel(categoryName: "food$i"));
        await repo.addCategory(models[i].categoryName);
      }

      final newModels = await repo.getUserCreatedCategories();

      ///Might be not in order thats why i have sorted it
      newModels.sort((a, b) => a.categoryName.compareTo(b.categoryName));
      models.sort((a, b) => a.categoryName.compareTo(b.categoryName));

      expect(newModels.length, 5);
      expect(listEquals(models, newModels), true);
    });
  });

  tearDownAll(() => db.close());
  tearDown(() => _cleanUp(db));
}
