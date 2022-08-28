import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_shows/domain/usecases/get_on_air_tv_shows.dart';
import 'package:tv_shows/presentation/bloc/home/now_playing/on_air_bloc.dart';

import '../../../data/dummy_data/dummy_objects_tv_show.dart';
import 'on_air_test.mocks.dart';

@GenerateMocks([GetOnAirTvShows])
void main() {
  late TvShowOnAirBloc nowPlayingBloc;
  late MockGetOnAirTvShows mockGetOnAirTvShows;

  setUp(() {
    mockGetOnAirTvShows = MockGetOnAirTvShows();
    nowPlayingBloc = TvShowOnAirBloc(mockGetOnAirTvShows);
  });

  final tTvShowList = [testTvShow];

  group('now playing tv shows', () {
    test('initial state must be empty', () {
      expect(nowPlayingBloc.state, isA<OnAirEmpty>());
    });
    blocTest<TvShowOnAirBloc, TvShowOnAirState>(
        'initial state should be empty',
        build: () {
          return nowPlayingBloc;
        },
        expect: () => []);

    blocTest<TvShowOnAirBloc, TvShowOnAirState>(
        'should get data from the usecase',
        build: () {
          when(mockGetOnAirTvShows.execute())
              .thenAnswer((realInvocation) async => Right(tTvShowList));
          return nowPlayingBloc;
        },
        act: (bloc) => bloc.add(OnAirFetched()),
        verify: (bloc) {
          verify(mockGetOnAirTvShows.execute());
        });

    blocTest<TvShowOnAirBloc, TvShowOnAirState>(
        'should change tv shows when data is gotten successfully',
        build: () {
          when(mockGetOnAirTvShows.execute())
              .thenAnswer((realInvocation) async => Right(tTvShowList));
          return nowPlayingBloc;
        },
        act: (bloc) => bloc.add(OnAirFetched()),
        expect: () => [OnAirLoading(), OnAirHasData(tTvShowList)]);

    blocTest<TvShowOnAirBloc, TvShowOnAirState>(
        'should return error when data is unsuccessful',
        build: () {
          when(mockGetOnAirTvShows.execute()).thenAnswer(
              (realInvocation) async => Left(ServerFailure('Server Failure')));
          return nowPlayingBloc;
        },
        act: (bloc) => bloc.add(OnAirFetched()),
        expect: () => [OnAirLoading(), OnAirError('Server Failure')]);
  });
}
