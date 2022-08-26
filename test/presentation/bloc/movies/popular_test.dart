import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movies/list/popular/popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movies/dummy_objects_movie.dart';
import 'popular_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MoviePopularBloc popularBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularBloc = MoviePopularBloc(mockGetPopularMovies);
  });

  final tMovieList = [testMovie];

  group('popular movies', () {

    test('initial state must be empty', () {
      expect(popularBloc.state, isA<PopularEmpty>());
    });

    blocTest<MoviePopularBloc, MoviePopularState>(
        'should get data from the usecase',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((realInvocation) async => Right(tMovieList));
          return popularBloc;
        },
        act: (bloc) => bloc.add(PopularFetched()),
        verify: (bloc) {
          verify(mockGetPopularMovies.execute());
        }
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
        'should change movies when data is gotten successfully',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((realInvocation) async => Right(tMovieList));
          return popularBloc;
        },
        act: (bloc) => bloc.add(PopularFetched()),
        expect: () => [
          PopularLoading(),
          PopularHasData(tMovieList)
        ]
    );

    blocTest<MoviePopularBloc, MoviePopularState>(
        'should return error when data is unsuccessful',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((realInvocation) async => Left(ServerFailure('Server Failure')));
          return popularBloc;
        },
        act: (bloc) => bloc.add(PopularFetched()),
        expect: () => [
          PopularLoading(),
          PopularError('Server Failure')
        ]
    );
  });
}
