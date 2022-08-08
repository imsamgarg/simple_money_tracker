import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_money_tracker/app/features/category/application/category_service.dart';
import 'package:simple_money_tracker/app/features/category/data/sqlite_category_repository.dart';
import 'package:simple_money_tracker/app/features/category/domain/category_model.dart';
import 'package:simple_money_tracker/app/features/transaction/domain/transaction_type_enum.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Listener extends Mock {
  void call(a, b);
}

void main() {
  late final ProviderContainer container;
  late final Database db;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    db = await openDatabase(inMemoryDatabasePath);
    final repo = SqliteCategoryRepository(db);
    await db.execute(SqliteCategoryRepository.kTableCreateQuery);

    final service = CategoryService(repo);
    container = ProviderContainer(
      overrides: [
        categoryServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(container.dispose);
  });

  test('category service', () async {
    final listener = Listener();
    final categoryService = container.read(categoryServiceProvider.notifier);
    List<CategoryModel> categories = [];

    container.listen<AsyncValue<List<CategoryModel>>>(
      categoryServiceProvider,
      (p, n) {
        listener(p, n);
        if (n.value != null) categories = n.value!;
      },
      fireImmediately: true,
    );

    await container.read(categoryServiceProvider.future);

    expect(categories, []);
    const asyncLoading = TypeMatcher<AsyncLoading>();
    const asyncData = TypeMatcher<AsyncData>();

    verify(listener(null, asyncLoading)).captured;
    verify(listener(asyncLoading, asyncData)).captured;

    await categoryService.addCategory(name: "a", type: TransactionType.expense);

    expect(categories.length, 1);
    verify(listener(asyncData, asyncData)).called(2);

    final model = categories[0];
    await categoryService.deleteCategory(model);

    verify(listener(asyncData, asyncData)).called(2);
  });

  tearDownAll(
    () async {
      await db.delete(SqliteCategoryRepository.kCategoryTableName);
      await db.close();
    },
  );
}
