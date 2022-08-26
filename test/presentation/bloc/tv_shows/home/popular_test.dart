import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/lib/utils/failure.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_popular_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv_shows/home/popular/popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/tv_shows/dummy_objects_tv_show.dart';
import 'popular_test.mocks.dart';


@GenerateMocks([GetPopularTvShows])
void main() {
  late TvShowPopularBloc popularBloc;
  late MockGetPopularTvShows mockGetPopularTvShows;

  setUp(() {
    mockGetPopularTvShows = MockGetPopularTvShows();
    popularBloc = TvShowPopularBloc(mockGetPopularTvShows);
  });

  final tTvShowList = [testTvShow];

  group('popular tv shows', () {
    test('initial state must be empty', () {
      expect(popularBloc.state, isA<PopularEmpty>());
    });

    blocTest<TvShowPopularBloc, TvShowPopularState>(
        'should get data from the usecase',
        build: () {
          when(mockGetPopularTvShows.execute())
              .thenAnswer((realInvocation) async => Right(tTvShowList));
          return popularBloc;
        },
        act: (bloc) => bloc.add(PopularFetched()),
        verify: (bloc) {
          verify(mockGetPopularTvShows.execute());
        });

    blocTest<TvShowPopularBloc, TvShowPopularState>(
        'should change tv shows when data is gotten successfully',
        build: () {
          when(mockGetPopularTvShows.execute())
              .thenAnswer((realInvocation) async => Right(tTvShowList));
          return popularBloc;
        },
        act: (bloc) => bloc.add(PopularFetched()),
        expect: () => [PopularLoading(), PopularHasData(tTvShowList)]);

    blocTest<TvShowPopularBloc, TvShowPopularState>(
        'should return error when data is unsuccessful',
        build: () {
          when(mockGetPopularTvShows.execute()).thenAnswer(
              (realInvocation) async => Left(ServerFailure('Server Failure')));
          return popularBloc;
        },
        act: (bloc) => bloc.add(PopularFetched()),
        expect: () => [PopularLoading(), PopularError('Server Failure')]);
  });
}
