import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
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
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTvShowRemoteDataSource();
    mockLocalDataSource = MockTvShowLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvShowRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
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
      overview: "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
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
    overview: "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
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
      when(mockRemoteDataSource.getOnAirTvShows())
          .thenAnswer((_) async => []);
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
}