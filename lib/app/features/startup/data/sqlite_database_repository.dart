// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  FutureOr<void> _onCreate(Database db, int version) {
    final query = queriesOnDatabaseCreation.join(";");
    return db.execute(query);
  }
}

final sqliteDatabaseProvider = Provider<SqliteDatabaseRepository>((ref) {
  throw UnimplementedError();
});
