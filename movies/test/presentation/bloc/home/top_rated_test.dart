import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/presentation/bloc/home/top_rated/top_rated_bloc.dart';

import '../../../data/dummy_data/dummy_objects_movie.dart';
import 'top_rated_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MovieTopRatedBloc topRatedBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedBloc = MovieTopRatedBloc(mockGetTopRatedMovies);
  });

  final tMovieList = [testMovie];

  group('top rated movies', () {
    test('initial state must be empty', () {
      expect(topRatedBloc.state, isA<TopRatedEmpty>());
    });

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
        'should get data from the usecase',
        build: () {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((realInvocation) async => Right(tMovieList));
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(TopRatedFetched()),
        verify: (bloc) {
          verify(mockGetTopRatedMovies.execute());
        });

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
        'should change movies when data is gotten successfully',
        build: () {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((realInvocation) async => Right(tMovieList));
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(TopRatedFetched()),
        expect: () => [TopRatedLoading(), TopRatedHasData(tMovieList)]);

    blocTest<MovieTopRatedBloc, MovieTopRatedState>(
        'should return error when data is unsuccessful',
        build: () {
          when(mockGetTopRatedMovies.execute()).thenAnswer(
              (realInvocation) async => Left(ServerFailure('Server Failure')));
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(TopRatedFetched()),
        expect: () => [TopRatedLoading(), TopRatedError('Server Failure')]);
  });
}
