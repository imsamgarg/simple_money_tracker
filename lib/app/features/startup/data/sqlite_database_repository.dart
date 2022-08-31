import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

// import 'package:sq';
const _kDatabaseVersion = 1;

class SqliteDatabaseRepository {
  SqliteDatabaseRepository(
    this.databasePath, {
    this.dbFactory,
    required this.queriesOnDatabaseCreation,
  });

  late final Database db;

  final String databasePath;
  final List<String> queriesOnDatabaseCreation;

  ///For Testing
  final DatabaseFactory? dbFactory;

  Future<Database> initialize() async {
    if (dbFactory != null) {
      databaseFactory = dbFactory;
    }

    return db = await openDatabase(
      databasePath,
      version: _kDatabaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    for (final query in queriesOnDatabaseCreation) {
      await db.execute(query);
    }
  }

  Batch batch() => db.batch();
}

final sqliteDatabaseProvider = Provider<SqliteDatabaseRepository>((ref) {
  throw UnimplementedError();
});
