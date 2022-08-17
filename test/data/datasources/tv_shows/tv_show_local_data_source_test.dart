import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/local/tv_show_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_shows/dummy_objects_tv_show.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvShowLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvShowLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlists', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(testWatchlistTvShowTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlist(testWatchlistTvShowTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(testWatchlistTvShowTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlist(testWatchlistTvShowTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlists', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(testWatchlistTvShowTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlist(testWatchlistTvShowTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(testWatchlistTvShowTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlist(testWatchlistTvShowTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TvShow Detail By Id', () {
    final tId = 1;

    test('should return TvShow Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvShowWatchlistById(tId))
          .thenAnswer((_) async => testMovieMap);
      // act
      final result = await dataSource.getTvShowById(tId);
      // assert
      expect(result, testWatchlistTvShowTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvShowWatchlistById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvShowById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlists tvshow', () {
    test('should return list of TvShowTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTvShow())
          .thenAnswer((_) async => [testMovieMap]);
      // act
      final result = await dataSource.getWatchlistTvShow();
      // assert
      expect(result, [testWatchlistTvShowTable]);
    });
  });

  group('cache on air tvshows', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearCacheTvShow('on air'))
          .thenAnswer((_) async => 1);
      // act
      await dataSource.cacheOnAirTvShow([testTvShowCache]);
      // assert
      verify(mockDatabaseHelper.clearCacheTvShow('on air'));
      verify(mockDatabaseHelper
          .insertCacheTvShowTransaction([testTvShowCache], 'on air'));
    });

    test('should return list of tvshow from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCachesTvShow('on air'))
          .thenAnswer((_) async => [testTvShowCacheMap]);
      // act
      final result = await dataSource.getCachedOnAirTvShow();
      // assert
      expect(result, [testTvShowCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getCachesTvShow('on air'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedOnAirTvShow();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
