import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:tv_shows/data/models/tv_show_table.dart';

class TvShowDatabaseHelper {
  static TvShowDatabaseHelper? _databaseHelper;

  TvShowDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory TvShowDatabaseHelper() => _databaseHelper ?? TvShowDatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblCacheTvShow = 'cache_tv_show';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton_tv_show.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblCacheTvShow (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
  }

  // tv shows
  Future<void> insertCacheTvShowTransaction(
      List<TvShowTable> tvShows, String category) async {
    final db = await database;
    db!.transaction((dbTransact) async {
      for (final tvShow in tvShows) {
        final tvShowJson = tvShow.toJson();
        tvShowJson['category'] = category;
        dbTransact.insert(_tblCacheTvShow, tvShowJson,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCachesTvShow(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCacheTvShow,
      where: 'category=?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearCacheTvShow(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCacheTvShow,
      where: 'category=?',
      whereArgs: [category],
    );
  }
}
