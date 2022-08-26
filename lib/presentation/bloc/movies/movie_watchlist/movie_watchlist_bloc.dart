import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlists/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlists/save_movie_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/transformers.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatus getWatchListStatus;
  final GetWatchlistMovies getWatchlistMovies;
  final SaveMovieWatchlist saveWatchlist;
  final RemoveMovieWatchlist removeWatchlist;

  MovieWatchlistBloc({
    required this.getWatchListStatus,
    required this.getWatchlistMovies,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieWatchlistInitial()) {
    on<MovieWatchlistStatusFetched>(
      _getMovieWatchlistStatus,
      transformer: (events, mapper) => events.switchMap(mapper),
    );

    on<MovieWatchlistFetched>(
      _getMovieWatchlist,
      transformer: (events, mapper) => events.switchMap(mapper),
    );

    on<MovieSavedToWatchlist>(
      _saveMovieToWatchlist,
      transformer: (events, mapper) => events.switchMap(mapper),
    );

    on<MovieRemovedFromWatchlist>(
      _removeMovieFromWatchlist,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
  }

  void _saveMovieToWatchlist(
    MovieSavedToWatchlist event,
    Emitter<MovieWatchlistState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);
    await result.fold(
      (failure) async {
        emit(MovieWatchlistStatusData(false, failure.message));
      },
      (successMessage) async {
        emit(MovieWatchlistStatusData(true, watchlistAddSuccessMessage));
      },
    );
  }

  void _removeMovieFromWatchlist(
    MovieRemovedFromWatchlist event,
    Emitter<MovieWatchlistState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);
    await result.fold(
      (failure) async {
        emit(MovieWatchlistStatusData(true, failure.message));
      },
      (successMessage) async {
        emit(MovieWatchlistStatusData(false, watchlistRemoveSuccessMessage));
      },
    );
  }

  void _getMovieWatchlistStatus(
    MovieWatchlistStatusFetched event,
    Emitter<MovieWatchlistState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id, true);
    final message =
        result ? watchlistAddSuccessMessage : watchlistRemoveSuccessMessage;
    emit(MovieWatchlistStatusData(result, message));
  }

  void _getMovieWatchlist(
    MovieWatchlistFetched event,
    Emitter<MovieWatchlistState> emit,
  ) async {
    emit(MovieWatchlistLoading());
    final result = await getWatchlistMovies.execute();
    result.fold((failure) {
      emit(MovieWatchlistError(failure.message));
    }, (data) {
      emit(MovieWatchlistHasData(data));
    });
  }
}
