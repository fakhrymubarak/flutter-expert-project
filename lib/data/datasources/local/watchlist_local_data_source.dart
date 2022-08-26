import 'package:core/core.dart';
import 'package:ditonton/data/datasources/local/db/database_helper.dart';
import 'package:ditonton/data/models/watchlist/watchlist_table.dart';

abstract class WatchlistLocalDataSource {
  Future<String> insertWatchlist(WatchlistTable watchlist);
  Future<String> removeWatchlist(WatchlistTable watchlist);

  Future<WatchlistTable?> getTvShowById(int id);
  Future<List<WatchlistTable>> getWatchlistTvShow();

  Future<WatchlistTable?> getMovieById(int id);
  Future<List<WatchlistTable>> getWatchlistMovies();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final DatabaseHelper databaseHelper;

  WatchlistLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(WatchlistTable watchlist) async {
    try {
      await databaseHelper.insertWatchlist(watchlist);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(WatchlistTable watchlist) async {
    try {
      await databaseHelper.removeWatchlist(watchlist);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<WatchlistTable?> getMovieById(int id) async {
    final result = await databaseHelper.getMovieWatchlistById(id);
    if (result != null) {
      return WatchlistTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchlistTable>> getWatchlistMovies() async {
    final result = await databaseHelper.getWatchlistMovies();
    return result.map((data) => WatchlistTable.fromMap(data)).toList();
  }

  @override
  Future<WatchlistTable?> getTvShowById(int id) async {
    final result = await databaseHelper.getTvShowWatchlistById(id);
    if (result != null) {
      return WatchlistTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchlistTable>> getWatchlistTvShow() async {
    final result = await databaseHelper.getWatchlistTvShow();
    return result.map((data) => WatchlistTable.fromMap(data)).toList();
  }
}
