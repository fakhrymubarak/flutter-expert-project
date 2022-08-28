import 'package:core/core.dart';
import 'package:movies/data/datasources/local/db/movie_database_helper.dart';
import 'package:movies/data/models/movie_table.dart';

abstract class MovieLocalDataSource {
  Future<void> cacheNowPlayingMovies(List<MovieTable> movies);

  Future<List<MovieTable>> getCachedNowPlayingMovies();

  Future<void> cachePopularMovies(List<MovieTable> movies);

  Future<List<MovieTable>> getCachedPopularMovies();

  Future<void> cacheTopRatedMovies(List<MovieTable> movies);

  Future<List<MovieTable>> getCachedTopRatedMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final MovieDatabaseHelper databaseHelper;

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheNowPlayingMovies(List<MovieTable> movies) async {
    await databaseHelper.clearCacheMovie('now playing');
    await databaseHelper.insertCacheMovieTransaction(movies, 'now playing');
  }

  @override
  Future<List<MovieTable>> getCachedNowPlayingMovies() async {
    final result = await databaseHelper.getCacheMovies('now playing');
    if (result.isNotEmpty) {
      return result.map((data) => MovieTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<void> cachePopularMovies(List<MovieTable> movies) async {
    await databaseHelper.clearCacheMovie('popular');
    await databaseHelper.insertCacheMovieTransaction(movies, 'popular');
  }

  @override
  Future<List<MovieTable>> getCachedPopularMovies() async {
    final result = await databaseHelper.getCacheMovies('popular');
    if (result.isNotEmpty) {
      return result.map((data) => MovieTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<void> cacheTopRatedMovies(List<MovieTable> movies) async {
    await databaseHelper.clearCacheMovie('top rated');
    await databaseHelper.insertCacheMovieTransaction(movies, 'top rated');
  }

  @override
  Future<List<MovieTable>> getCachedTopRatedMovies() async {
    final result = await databaseHelper.getCacheMovies('top rated');
    if (result.isNotEmpty) {
      return result.map((data) => MovieTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}
