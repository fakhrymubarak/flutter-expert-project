import 'dart:async';

import 'package:movies/data/models/movie_table.dart';
import 'package:sqflite/sqflite.dart';

class MovieDatabaseHelper {
  static MovieDatabaseHelper? _databaseHelper;

  MovieDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory MovieDatabaseHelper() => _databaseHelper ?? MovieDatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblCacheMovie = 'cache_movie';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton_movie.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblCacheMovie (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
  }

  // movies
  Future<void> insertCacheMovieTransaction(
      List<MovieTable> movies, String category) async {
    final db = await database;
    db!.transaction((dbTransact) async {
      for (final movie in movies) {
        final movieJson = movie.toJson();
        movieJson['category'] = category;
        dbTransact.insert(_tblCacheMovie, movieJson,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCacheMovie,
      where: 'category=?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearCacheMovie(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCacheMovie,
      where: 'category=?',
      whereArgs: [category],
    );
  }
}
