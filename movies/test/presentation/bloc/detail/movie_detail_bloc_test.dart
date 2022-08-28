import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/presentation/bloc/details/movie_detail_bloc.dart';

import '../../../data/dummy_data/dummy_objects_movie.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
])
void main() {
  late MovieDetailBloc movieDetailsBloc;

  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();

    movieDetailsBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
    );
  });

  const tId = 1;
  final tMovies = [testMovie];

  group('Get Movie Details', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when get movie details is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieDetailsBloc;
      },
      act: (bloc) => bloc.add(MovieDetailFetched(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailError('Server Failure', ''),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, HasData] when get movie details is successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return movieDetailsBloc;
      },
      act: (bloc) => bloc.add(MovieDetailFetched(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailHasData(testMovieDetail, tMovies),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });
}
