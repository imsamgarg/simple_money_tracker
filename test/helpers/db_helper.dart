import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> initSqliteInMemoryDb() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  return openDatabase(inMemoryDatabasePath);
}
