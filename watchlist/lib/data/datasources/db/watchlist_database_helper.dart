import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../models/watchlist_table.dart';

class WatchlistDatabaseHelper {
  static WatchlistDatabaseHelper? _databaseHelper;

  WatchlistDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory WatchlistDatabaseHelper() => _databaseHelper ?? WatchlistDatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlists';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton_watchlist.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        type INTEGER
      );
    ''');
  }

  // watchlist
  Future<int> insertWatchlist(WatchlistTable watchlist) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, watchlist.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> removeWatchlist(WatchlistTable watchlist) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id=?',
      whereArgs: [watchlist.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieWatchlistById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id=? AND type=?',
      whereArgs: [id, 1],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTvShowWatchlistById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id=? AND type=?',
      whereArgs: [id, 2],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'type=?',
      whereArgs: [1],
    );

    return results;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvShow() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'type=?',
      whereArgs: [2],
    );

    return results;
  }
}
