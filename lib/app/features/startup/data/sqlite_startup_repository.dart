// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:sqflite/sqflite.dart';

// import 'package:sq';
const _kDatabaseVersion = 1;

class SqliteStartupRepository {
  const SqliteStartupRepository(
    this.databasePath, {
    this.dbFactory,
    required this.queriesOnDatabaseCreation,
  });

  final String databasePath;
  final List<String> queriesOnDatabaseCreation;

  ///For Testing
  final DatabaseFactory? dbFactory;

  Future<Database> initialize() {
    if (dbFactory != null) {
      databaseFactory = dbFactory;
    }

    return openDatabase(
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
