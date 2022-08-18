import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_shows/author_model.dart';
import 'package:ditonton/data/models/tv_shows/episode_model.dart';
import 'package:ditonton/data/models/tv_shows/network_model.dart';
import 'package:ditonton/data/models/tv_shows/season_model.dart';
import 'package:ditonton/data/models/tv_shows/tv_show_detail_model.dart';
import 'package:ditonton/data/models/tv_shows/tv_shows_model.dart';
import 'package:ditonton/data/repositories/tv_shows_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_shows/dummy_objects_tv_show.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvShowRepositoryImpl repository;
  late MockTvShowRemoteDataSource mockRemoteDataSource;
  late MockTvShowLocalDataSource mockLocalDataSource;
  late MockWatchlistLocalDataSource mockWLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTvShowRemoteDataSource();
    mockLocalDataSource = MockTvShowLocalDataSource();
    mockWLocalDataSource = MockWatchlistLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvShowRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      wLocalDataSource: mockWLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTvShowModel = TvShowModel(
    backdropPath: "/hNwopoqRDazw1uPHY2jSNmV2gS2.jpg",
    firstAirDate: "2005-06-06",
    genreIds: [10763, 10764, 99],
    id: 203599,
    name: "Scoop",
    originCountry: ["US", "ID"],
    originalLanguage: "cn",
    originalName: "東張西望",
    overview:
        "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
    popularity: 1346.379,
    posterPath: "/qo6y0XvSBlKM3XCbYVdcR3a6qyQ.jpg",
    voteAverage: 7.6,
    voteCount: 5,
  );

  final tTvShow = TvShow(
    backdropPath: "/hNwopoqRDazw1uPHY2jSNmV2gS2.jpg",
    firstAirDate: "2005-06-06",
    genreIds: [10763, 10764, 99],
    id: 203599,
    name: "Scoop",
    originCountry: ["US", "ID"],
    originalLanguage: "cn",
    originalName: "東張西望",
    overview:
        "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
    popularity: 1346.379,
    posterPath: "/qo6y0XvSBlKM3XCbYVdcR3a6qyQ.jpg",
    voteAverage: 7.6,
    voteCount: 5,
  );

  final tTvShowModelList = <TvShowModel>[tTvShowModel];
  final tTvShowList = <TvShow>[tTvShow];

  group('On Air Tv Shows', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getOnAirTvShows()).thenAnswer((_) async => []);
      // act
      await repository.getOnAirTvShows();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getOnAirTvShows())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        final result = await repository.getOnAirTvShows();
        // assert
        verify(mockRemoteDataSource.getOnAirTvShows());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvShowList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getOnAirTvShows())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        await repository.getOnAirTvShows();
        // assert
        verify(mockRemoteDataSource.getOnAirTvShows());
        verify(mockLocalDataSource.cacheOnAirTvShow([testTvShowCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getOnAirTvShows())
            .thenThrow(ServerException());
        // act
        final result = await repository.getOnAirTvShows();
        // assert
        verify(mockRemoteDataSource.getOnAirTvShows());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedOnAirTvShow())
            .thenAnswer((_) async => [testTvShowCache]);
        // act
        final result = await repository.getOnAirTvShows();
        // assert
        verify(mockLocalDataSource.getCachedOnAirTvShow());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvShowFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedOnAirTvShow())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getOnAirTvShows();
        // assert
        verify(mockLocalDataSource.getCachedOnAirTvShow());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Popular Tv Shows', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getPopularTvShows())
          .thenAnswer((_) async => []);
      // act
      await repository.getPopularTvShows();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvShows())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        final result = await repository.getPopularTvShows();
        // assert
        verify(mockRemoteDataSource.getPopularTvShows());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvShowList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvShows())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        await repository.getPopularTvShows();
        // assert
        verify(mockRemoteDataSource.getPopularTvShows());
        verify(mockLocalDataSource.cachePopularTvShow([testTvShowCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvShows())
            .thenThrow(ServerException());
        // act
        final result = await repository.getPopularTvShows();
        // assert
        verify(mockRemoteDataSource.getPopularTvShows());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedPopularTvShow())
            .thenAnswer((_) async => [testTvShowCache]);
        // act
        final result = await repository.getPopularTvShows();
        // assert
        verify(mockLocalDataSource.getCachedPopularTvShow());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvShowFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedPopularTvShow())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getPopularTvShows();
        // assert
        verify(mockLocalDataSource.getCachedPopularTvShow());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Top Rated Tv Shows', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getTopRatedTvShows())
          .thenAnswer((_) async => []);
      // act
      await repository.getTopRatedTvShows();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTvShows())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        final result = await repository.getTopRatedTvShows();
        // assert
        verify(mockRemoteDataSource.getTopRatedTvShows());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvShowList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTvShows())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        await repository.getTopRatedTvShows();
        // assert
        verify(mockRemoteDataSource.getTopRatedTvShows());
        verify(mockLocalDataSource.cacheTopRatedTvShow([testTvShowCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTvShows())
            .thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTvShows();
        // assert
        verify(mockRemoteDataSource.getTopRatedTvShows());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedTopRatedTvShow())
            .thenAnswer((_) async => [testTvShowCache]);
        // act
        final result = await repository.getTopRatedTvShows();
        // assert
        verify(mockLocalDataSource.getCachedTopRatedTvShow());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvShowFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedTopRatedTvShow())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getTopRatedTvShows();
        // assert
        verify(mockLocalDataSource.getCachedTopRatedTvShow());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Get TvShow Detail', () {
    final tId = 1;
    final tTvShowResponse = TvShowDetailResponse(
      adult: false,
      backdropPath: "backdropPath",
      createdBy: [
        AuthorModel(
            id: 1,
            creditId: "creditId",
            name: "name",
            gender: 2,
            profilePath: "/profilePath")
      ],
      episodeRunTime: [1],
      firstAirDate: DateTime(2020, 12, 31),
      genres: [GenreModel(id: 1, name: "name")],
      homepage: "homepage",
      id: 1,
      inProduction: false,
      languages: ["languages"],
      lastAirDate: DateTime(2020, 12, 31),
      lastEpisodeToAir: EpisodeModel(
          airDate: DateTime(2020, 12, 31),
          episodeNumber: 5,
          id: 1,
          name: "name",
          overview: "overview",
          productionCode: "productionCode",
          runtime: 1,
          seasonNumber: 1,
          showId: 1,
          stillPath: "stillPath",
          voteAverage: 1,
          voteCount: 1),
      name: "name",
      nextEpisodeToAir: EpisodeModel(
          airDate: DateTime(2020, 12, 31),
          episodeNumber: 5,
          id: 1,
          name: "name",
          overview: "overview",
          productionCode: "productionCode",
          runtime: 1,
          seasonNumber: 1,
          showId: 1,
          stillPath: "stillPath",
          voteAverage: 1,
          voteCount: 1),
      networks: [NetworkModel(id: 1, name: "name", logoPath: "logoPath", originCountry: "originCountry")],
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originCountry: ["en"],
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 1,
      posterPath: "posterPath",
      productionCompanies: [NetworkModel(id: 1, name: "name", logoPath: "logoPath", originCountry: "originCountry")],
      seasons: [
        SeasonModel(
            airDate: DateTime(2020, 12, 31),
            episodeCount: 1,
            id: 1,
            name: "name",
            overview: "overview",
            posterPath: "posterPath",
            seasonNumber: 1)
      ],
      status: "status",
      tagline: "tagline",
      type: "type",
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return TvShow data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowDetail(tId))
          .thenAnswer((_) async => tTvShowResponse);
      // act
      final result = await repository.getTvShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowDetail(tId));
      expect(result, equals(Right(testTvShowDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvShowDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TvShow Recommendations', () {
    final tTvShowList = <TvShowModel>[];
    final tId = 1;

    test('should return data (tv show list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowRecommendations(tId))
          .thenAnswer((_) async => tTvShowList);
      // act
      final result = await repository.getTvShowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvShowList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvShowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvShowRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvShowRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvShowRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('save watchlists', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockWLocalDataSource.insertWatchlist(testWatchlistTvShowTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvShowDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockWLocalDataSource.insertWatchlist(testWatchlistTvShowTable))
          .thenThrow(DatabaseException('Failed to add watchlists'));
      // act
      final result = await repository.saveWatchlist(testTvShowDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlists')));
    });
  });

  group('remove watchlists', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockWLocalDataSource.removeWatchlist(testWatchlistTvShowTable))
          .thenAnswer((_) async => 'Removed from watchlists');
      // act
      final result = await repository.removeWatchlist(testTvShowDetail);
      // assert
      expect(result, Right('Removed from watchlists'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockWLocalDataSource.removeWatchlist(testWatchlistTvShowTable))
          .thenThrow(DatabaseException('Failed to remove watchlists'));
      // act
      final result = await repository.removeWatchlist(testTvShowDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlists')));
    });
  });

  group('get watchlists status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockWLocalDataSource.getTvShowById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlists tv show', () {
    test('should return list of TvShows', () async {
      // arrange
      when(mockWLocalDataSource.getWatchlistTvShow())
          .thenAnswer((_) async => [testWatchlistTvShowTable]);
      // act
      final result = await repository.getWatchlistTvShow();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvShow]);
    });
  });
}
