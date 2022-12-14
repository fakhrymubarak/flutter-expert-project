import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_shows/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:tv_shows/presentation/bloc/home/top_rated/top_rated_bloc.dart';

import '../../../../../tv_shows/test/data/dummy_data/dummy_objects_tv_show.dart';
import 'top_rated_test.mocks.dart';

@GenerateMocks([GetTopRatedTvShows])
void main() {
  late TvShowTopRatedBloc topRatedBloc;
  late MockGetTopRatedTvShows mockGetTopRatedTvShows;

  setUp(() {
    mockGetTopRatedTvShows = MockGetTopRatedTvShows();
    topRatedBloc = TvShowTopRatedBloc(mockGetTopRatedTvShows);
  });

  final tTvShowList = [testTvShow];

  group('top rated tv shows', () {
    test('initial state must be empty', () {
      expect(topRatedBloc.state, isA<TopRatedEmpty>());
    });

    blocTest<TvShowTopRatedBloc, TvShowTopRatedState>(
        'should get data from the usecase',
        build: () {
          when(mockGetTopRatedTvShows.execute())
              .thenAnswer((realInvocation) async => Right(tTvShowList));
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(TopRatedFetched()),
        verify: (bloc) {
          verify(mockGetTopRatedTvShows.execute());
        });

    blocTest<TvShowTopRatedBloc, TvShowTopRatedState>(
        'should change tv shows when data is gotten successfully',
        build: () {
          when(mockGetTopRatedTvShows.execute())
              .thenAnswer((realInvocation) async => Right(tTvShowList));
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(TopRatedFetched()),
        expect: () => [TopRatedLoading(), TopRatedHasData(tTvShowList)]);

    blocTest<TvShowTopRatedBloc, TvShowTopRatedState>(
        'should return error when data is unsuccessful',
        build: () {
          when(mockGetTopRatedTvShows.execute()).thenAnswer(
              (realInvocation) async => Left(ServerFailure('Server Failure')));
          return topRatedBloc;
        },
        act: (bloc) => bloc.add(TopRatedFetched()),
        expect: () => [TopRatedLoading(), TopRatedError('Server Failure')]);
  });
}
