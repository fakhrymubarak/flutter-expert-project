import 'package:core/core.dart';
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

  group('cache popular tvshows', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearCacheTvShow('popular'))
          .thenAnswer((_) async => 1);
      // act
      await dataSource.cachePopularTvShow([testTvShowCache]);
      // assert
      verify(mockDatabaseHelper.clearCacheTvShow('popular'));
      verify(mockDatabaseHelper
          .insertCacheTvShowTransaction([testTvShowCache], 'popular'));
    });

    test('should return list of tvshow from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCachesTvShow('popular'))
          .thenAnswer((_) async => [testTvShowCacheMap]);
      // act
      final result = await dataSource.getCachedPopularTvShow();
      // assert
      expect(result, [testTvShowCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getCachesTvShow('popular'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedPopularTvShow();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('cache top rated tvshows', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearCacheTvShow('top rated'))
          .thenAnswer((_) async => 1);
      // act
      await dataSource.cacheTopRatedTvShow([testTvShowCache]);
      // assert
      verify(mockDatabaseHelper.clearCacheTvShow('top rated'));
      verify(mockDatabaseHelper
          .insertCacheTvShowTransaction([testTvShowCache], 'top rated'));
    });

    test('should return list of tvshow from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCachesTvShow('top rated'))
          .thenAnswer((_) async => [testTvShowCacheMap]);
      // act
      final result = await dataSource.getCachedTopRatedTvShow();
      // assert
      expect(result, [testTvShowCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getCachesTvShow('top rated'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedTopRatedTvShow();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
