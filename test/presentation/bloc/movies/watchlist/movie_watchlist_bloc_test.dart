import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/lib/utils/failure.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlists/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlists/save_movie_watchlist.dart';
import 'package:ditonton/presentation/bloc/movies/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/movies/dummy_objects_movie.dart';
import 'movie_watchlist_bloc_test.mocks.dart';


@GenerateMocks([
  GetWatchListStatus,
  GetWatchlistMovies,
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
])
void main() {
  late MovieWatchlistBloc movieWatchlistBloc;

  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockSaveMovieWatchlist mockSaveWatchlist;
  late MockRemoveMovieWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockSaveWatchlist = MockSaveMovieWatchlist();
    mockRemoveWatchlist = MockRemoveMovieWatchlist();

    movieWatchlistBloc = MovieWatchlistBloc(
      getWatchListStatus: mockGetWatchlistStatus,
      getWatchlistMovies: mockGetWatchlistMovies,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;
  final tMovies = [testMovie];
  group('Watchlist', () {
    test('initial state must be initial', () {
      expect(movieWatchlistBloc.state, isA<MovieWatchlistInitial>());
    });

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [MovieWatchlistStatus] when get watchlist status successful',
      build: () {
        when(mockGetWatchlistStatus.execute(tId, true))
            .thenAnswer((_) async => true);
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlistStatusFetched(tId)),
      expect: () => [
        MovieWatchlistStatusData(
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
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(MovieSavedToWatchlist(testMovieDetail)),
      expect: () => [
        MovieWatchlistStatusData(
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
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(MovieRemovedFromWatchlist(testMovieDetail)),
      expect: () => [
        MovieWatchlistStatusData(
            false, MovieWatchlistBloc.watchlistRemoveSuccessMessage)
      ],
      verify: (bloc) {
        verify(
          mockRemoveWatchlist.execute(testMovieDetail),
        );
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [Loading, Error] when get watchlist movies unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlistFetched()),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistError('Database Failure'),
      ],
      verify: (bloc) {
        verify(
          mockGetWatchlistMovies.execute(),
        );
      },
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      'Should emit [Loading, HasData] when get watchlist movies successful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(MovieWatchlistFetched()),
      expect: () => [
        MovieWatchlistLoading(),
        MovieWatchlistHasData(tMovies),
      ],
      verify: (bloc) {
        verify(
          mockGetWatchlistMovies.execute(),
        );
      },
    );
  });
}
