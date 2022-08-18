import 'dart:async';

import 'package:ditonton/data/models/movies/movie_table.dart';
import 'package:ditonton/data/models/tv_shows/tv_show_table.dart';
import 'package:ditonton/data/models/watchlist/watchlist_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblWatchlist = 'watchlists';
  static const String _tblCacheMovie = 'cache_movie';
  static const String _tblCacheTvShow = 'cache_tv_show';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

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

    await db.execute('''
      CREATE TABLE  $_tblCacheMovie (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');

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
