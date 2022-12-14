import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_shows/domain/usecases/get_recommendation_tv_show.dart';
import 'package:tv_shows/domain/usecases/get_tv_show_detail.dart';
import 'package:tv_shows/presentation/bloc/details/tv_show_detail_bloc.dart';

import '../../../data/dummy_data/dummy_objects_tv_show.dart';
import 'tv_show_detail_bloc_test.mocks.dart';


@GenerateMocks([
  GetTvShowDetail,
  GetTvShowRecommendations,
])
void main() {
  late TvShowDetailBloc tvShowDetailsBloc;

  late MockGetTvShowDetail mockGetTvShowDetail;
  late MockGetTvShowRecommendations mockGetTvShowRecommendations;

  setUp(() {
    mockGetTvShowDetail = MockGetTvShowDetail();
    mockGetTvShowRecommendations = MockGetTvShowRecommendations();

    tvShowDetailsBloc = TvShowDetailBloc(
      getTvShowDetail: mockGetTvShowDetail,
      getTvShowRecommendations: mockGetTvShowRecommendations,
    );
  });

  final tId = 1;
  final tTvShows = [testTvShow];

  group('Get TvShow Details', () {
    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'Should emit [Loading, Error] when get tv show details is unsuccessful',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvShowDetailsBloc;
      },
      act: (bloc) => bloc.add(TvShowDetailFetched(tId)),
      expect: () => [
        TvShowDetailLoading(),
        TvShowDetailError('Server Failure', ''),
      ],
      verify: (bloc) {
        verify(mockGetTvShowDetail.execute(tId));
      },
    );

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'Should emit [Loading, HasData] when get tv show details is successfully',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvShowDetail));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvShows));
        return tvShowDetailsBloc;
      },
      act: (bloc) => bloc.add(TvShowDetailFetched(tId)),
      expect: () => [
        TvShowDetailLoading(),
        TvShowDetailHasData(testTvShowDetail, tTvShows),
      ],
      verify: (bloc) {
        verify(mockGetTvShowDetail.execute(tId));
      },
    );
  });
}
