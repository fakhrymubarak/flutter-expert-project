import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_shows/domain/usecases/watchlist/get_watchlist_status.dart';
import 'package:tv_shows/domain/usecases/watchlist/get_watchlist_tv_shows.dart';
import 'package:tv_shows/domain/usecases/watchlist/remove_tv_show_watchlist.dart';
import 'package:tv_shows/domain/usecases/watchlist/save_tv_show_watchlist.dart';
import 'package:tv_shows/presentation/bloc/tv_show_watchlist/tv_show_watchlist_bloc.dart';

import '../../../data/dummy_data/dummy_objects_tv_show.dart';
import 'tv_show_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvShowWatchListStatus,
  GetWatchlistTvShows,
  SaveTvShowWatchlist,
  RemoveTvShowWatchlist,
])
void main() {
  late TvShowWatchlistBloc tvShowWatchlistBloc;

  late MockGetTvShowWatchListStatus mockGetWatchlistStatus;
  late MockGetWatchlistTvShows mockGetWatchlistTvShows;
  late MockSaveTvShowWatchlist mockSaveWatchlist;
  late MockRemoveTvShowWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistStatus = MockGetTvShowWatchListStatus();
    mockGetWatchlistTvShows = MockGetWatchlistTvShows();
    mockSaveWatchlist = MockSaveTvShowWatchlist();
    mockRemoveWatchlist = MockRemoveTvShowWatchlist();

    tvShowWatchlistBloc = TvShowWatchlistBloc(
      getWatchListStatus: mockGetWatchlistStatus,
      getWatchlistTvShows: mockGetWatchlistTvShows,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;
  final tTvShows = [testTvShow];
  group('Watchlist', () {
    test('initial state must be initial', () {
      expect(tvShowWatchlistBloc.state, isA<TvShowWatchlistInitial>());
    });

    blocTest<TvShowWatchlistBloc, TvShowWatchlistState>(
      'Should emit [TvShowWatchlistStatus] when get watchlist status successful',
      build: () {
        when(mockGetWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return tvShowWatchlistBloc;
      },
      act: (bloc) => bloc.add(TvShowWatchlistStatusFetched(tId)),
      expect: () => [
        TvShowWatchlistStatusData(
            true, TvShowWatchlistBloc.watchlistAddSuccessMessage),
      ],
      verify: (bloc) {
        verify(
          mockGetWatchlistStatus.execute(tId),
        );
      },
    );

    blocTest<TvShowWatchlistBloc, TvShowWatchlistState>(
      'Should emit [TvShowWatchlistMessage] when success save watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testTvShowDetail))
            .thenAnswer((_) async => Right('Success'));
        return tvShowWatchlistBloc;
      },
      act: (bloc) => bloc.add(TvShowSavedToWatchlist(testTvShowDetail)),
      expect: () => [
        TvShowWatchlistStatusData(
            true, TvShowWatchlistBloc.watchlistAddSuccessMessage),
      ],
      verify: (bloc) {
        verify(
          mockSaveWatchlist.execute(testTvShowDetail),
        );
      },
    );

    blocTest<TvShowWatchlistBloc, TvShowWatchlistState>(
      'Should emit [TvShowWatchlistMessage] when success remove watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testTvShowDetail))
            .thenAnswer((_) async => Right('Removed'));
        return tvShowWatchlistBloc;
      },
      act: (bloc) => bloc.add(TvShowRemovedFromWatchlist(testTvShowDetail)),
      expect: () => [
        TvShowWatchlistStatusData(
            false, TvShowWatchlistBloc.watchlistRemoveSuccessMessage)
      ],
      verify: (bloc) {
        verify(
          mockRemoveWatchlist.execute(testTvShowDetail),
        );
      },
    );

    blocTest<TvShowWatchlistBloc, TvShowWatchlistState>(
      'Should emit [Loading, Error] when get watchlist tvShows unsuccessful',
      build: () {
        when(mockGetWatchlistTvShows.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return tvShowWatchlistBloc;
      },
      act: (bloc) => bloc.add(TvShowWatchlistFetched()),
      expect: () => [
        TvShowWatchlistLoading(),
        TvShowWatchlistError('Database Failure'),
      ],
      verify: (bloc) {
        verify(
          mockGetWatchlistTvShows.execute(),
        );
      },
    );

    blocTest<TvShowWatchlistBloc, TvShowWatchlistState>(
      'Should emit [Loading, HasData] when get watchlist tvShows successful',
      build: () {
        when(mockGetWatchlistTvShows.execute())
            .thenAnswer((_) async => Right(tTvShows));
        return tvShowWatchlistBloc;
      },
      act: (bloc) => bloc.add(TvShowWatchlistFetched()),
      expect: () => [
        TvShowWatchlistLoading(),
        TvShowWatchlistHasData(tTvShows),
      ],
      verify: (bloc) {
        verify(
          mockGetWatchlistTvShows.execute(),
        );
      },
    );
  });
}
