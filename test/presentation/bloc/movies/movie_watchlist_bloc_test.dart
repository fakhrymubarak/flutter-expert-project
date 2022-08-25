import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlists/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlists/save_movie_watchlist.dart';
import 'package:ditonton/presentation/bloc/movies/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movies/dummy_objects_movie.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatus,
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
])
void main() {
  late MovieWatchlistBloc movieDetailsBloc;

  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveMovieWatchlist mockSaveWatchlist;
  late MockRemoveMovieWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveMovieWatchlist();
    mockRemoveWatchlist = MockRemoveMovieWatchlist();

    movieDetailsBloc = MovieWatchlistBloc(
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;

  group('Watchlist', () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [MovieWatchlistStatus] when get watchlist status successful',
      build: () {
        when(mockGetWatchlistStatus.execute(tId, true))
            .thenAnswer((_) async => true);
        return movieDetailsBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlistStatusFetched(tId)),
      expect: () => [
        MovieWatchlistHasData(
            true, MovieWatchlistBloc.watchlistAddSuccessMessage),
      ],
      verify: (bloc) {
        verify(
          mockGetWatchlistStatus.execute(tId, true),
        );
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [MovieWatchlistMessage] when success save watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Success'));
        return movieDetailsBloc;
      },
      act: (bloc) => bloc.add(MovieSavedToWatchlist(testMovieDetail)),
      expect: () => [
        MovieWatchlistHasData(
            true, MovieWatchlistBloc.watchlistAddSuccessMessage),
      ],
      verify: (bloc) {
        verify(
          mockSaveWatchlist.execute(testMovieDetail),
        );
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [MovieWatchlistMessage] when success remove watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed'));
        return movieDetailsBloc;
      },
      act: (bloc) => bloc.add(MovieRemovedFromWatchlist(testMovieDetail)),
      expect: () => [
        MovieWatchlistHasData(
            false, MovieWatchlistBloc.watchlistRemoveSuccessMessage)
      ],
      verify: (bloc) {
        verify(
          mockRemoveWatchlist.execute(testMovieDetail),
        );
      },
    );
  });
}
