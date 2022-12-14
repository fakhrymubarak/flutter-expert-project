import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/presentation/bloc/home/now_playing/now_playing_bloc.dart';

import '../../../data/dummy_data/dummy_objects_movie.dart';
import 'now_playing_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MovieNowPlayingBloc nowPlayingBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingBloc = MovieNowPlayingBloc(mockGetNowPlayingMovies);
  });

  final tMovieList = [testMovie];

  group('now playing movies', () {
    test('initial state must be empty', () {
      expect(nowPlayingBloc.state, isA<NowPlayingEmpty>());
    });

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
        'should get data from the usecase',
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((realInvocation) async => Right(tMovieList));
          return nowPlayingBloc;
        },
        act: (bloc) => bloc.add(NowPlayingFetched()),
        verify: (bloc) {
          verify(mockGetNowPlayingMovies.execute());
        });

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
        'should change movies when data is gotten successfully',
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((realInvocation) async => Right(tMovieList));
          return nowPlayingBloc;
        },
        act: (bloc) => bloc.add(NowPlayingFetched()),
        expect: () => [NowPlayingLoading(), NowPlayingHasData(tMovieList)]);

    blocTest<MovieNowPlayingBloc, MovieNowPlayingState>(
        'should return error when data is unsuccessful',
        build: () {
          when(mockGetNowPlayingMovies.execute()).thenAnswer(
              (realInvocation) async => Left(ServerFailure('Server Failure')));
          return nowPlayingBloc;
        },
        act: (bloc) => bloc.add(NowPlayingFetched()),
        expect: () => [NowPlayingLoading(), NowPlayingError('Server Failure')]);
  });
}
