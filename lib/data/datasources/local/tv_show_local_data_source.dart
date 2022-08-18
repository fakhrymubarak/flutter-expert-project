import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/local/db/database_helper.dart';
import 'package:ditonton/data/models/tv_shows/tv_show_table.dart';

abstract class TvShowLocalDataSource {
  Future<void> cacheOnAirTvShow(List<TvShowTable> tvShows);

  Future<List<TvShowTable>> getCachedOnAirTvShow();

  Future<void> cachePopularTvShow(List<TvShowTable> tvShows);

  Future<List<TvShowTable>> getCachedPopularTvShow();

  Future<void> cacheTopRatedTvShow(List<TvShowTable> tvShows);

  Future<List<TvShowTable>> getCachedTopRatedTvShow();
}

class TvShowLocalDataSourceImpl implements TvShowLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvShowLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheOnAirTvShow(List<TvShowTable> tvShows) async {
    await databaseHelper.clearCacheTvShow('on air');
    await databaseHelper.insertCacheTvShowTransaction(tvShows, 'on air');
  }

  @override
  Future<List<TvShowTable>> getCachedOnAirTvShow() async {
    final result = await databaseHelper.getCachesTvShow('on air');
    if (result.length > 0) {
      return result.map((data) => TvShowTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<void> cachePopularTvShow(List<TvShowTable> tvShows) async {
    await databaseHelper.clearCacheTvShow('popular');
    await databaseHelper.insertCacheTvShowTransaction(tvShows, 'popular');
  }

  @override
  Future<List<TvShowTable>> getCachedPopularTvShow() async {
    final result = await databaseHelper.getCachesTvShow('popular');
    if (result.length > 0) {
      return result.map((data) => TvShowTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<void> cacheTopRatedTvShow(List<TvShowTable> tvShows) async {
    await databaseHelper.clearCacheTvShow('top rated');
    await databaseHelper.insertCacheTvShowTransaction(tvShows, 'top rated');
  }

  @override
  Future<List<TvShowTable>> getCachedTopRatedTvShow() async {
    final result = await databaseHelper.getCachesTvShow('top rated');
    if (result.length > 0) {
      return result.map((data) => TvShowTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}
