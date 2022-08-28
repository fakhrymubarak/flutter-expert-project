import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/data/datasources/local/movie_local_data_source.dart';

import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/dummy_objects_movie.dart';


void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('cache now playing movies', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearCacheMovie('now playing'))
          .thenAnswer((_) async => 1);
      // act
      await dataSource.cacheNowPlayingMovies([testMovieCache]);
      // assert
      verify(mockDatabaseHelper.clearCacheMovie('now playing'));
      verify(mockDatabaseHelper
          .insertCacheMovieTransaction([testMovieCache], 'now playing'));
    });

    test('should return list of movies from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheMovies('now playing'))
          .thenAnswer((_) async => [testMovieCacheMap]);
      // act
      final result = await dataSource.getCachedNowPlayingMovies();
      // assert
      expect(result, [testMovieCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheMovies('now playing'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedNowPlayingMovies();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('cache popular movies', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearCacheMovie('popular'))
          .thenAnswer((_) async => 1);
      // act
      await dataSource.cachePopularMovies([testMovieCache]);
      // assert
      verify(mockDatabaseHelper.clearCacheMovie('popular'));
      verify(mockDatabaseHelper
          .insertCacheMovieTransaction([testMovieCache], 'popular'));
    });

    test('should return list of movies from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheMovies('popular'))
          .thenAnswer((_) async => [testMovieCacheMap]);
      // act
      final result = await dataSource.getCachedPopularMovies();
      // assert
      expect(result, [testMovieCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheMovies('popular'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedPopularMovies();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('cache top rated movies', () {
    test('should call database helper to save data', () async {
      // arrange
      when(mockDatabaseHelper.clearCacheMovie('top rated'))
          .thenAnswer((_) async => 1);
      // act
      await dataSource.cacheTopRatedMovies([testMovieCache]);
      // assert
      verify(mockDatabaseHelper.clearCacheMovie('top rated'));
      verify(mockDatabaseHelper
          .insertCacheMovieTransaction([testMovieCache], 'top rated'));
    });

    test('should return list of movies from db when data exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheMovies('top rated'))
          .thenAnswer((_) async => [testMovieCacheMap]);
      // act
      final result = await dataSource.getCachedTopRatedMovies();
      // assert
      expect(result, [testMovieCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      // arrange
      when(mockDatabaseHelper.getCacheMovies('top rated'))
          .thenAnswer((_) async => []);
      // act
      final call = dataSource.getCachedTopRatedMovies();
      // assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
