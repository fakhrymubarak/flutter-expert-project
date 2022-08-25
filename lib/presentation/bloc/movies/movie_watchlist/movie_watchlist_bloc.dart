import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
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
  final SaveMovieWatchlist saveWatchlist;
  final RemoveMovieWatchlist removeWatchlist;

  MovieWatchlistBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieWatchlistInitial()) {
    on<MovieWatchlistStatusFetched>(
      _getMovieWatchlistStatus,
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
        emit(MovieWatchlistHasData(false, failure.message));
      },
      (successMessage) async {
        emit(MovieWatchlistHasData(true, watchlistAddSuccessMessage));
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
        emit(MovieWatchlistHasData(true, failure.message));
      },
      (successMessage) async {
        emit(MovieWatchlistHasData(false, watchlistRemoveSuccessMessage));
      },
    );
  }

  void _getMovieWatchlistStatus(
    MovieWatchlistStatusFetched event,
    Emitter<MovieWatchlistState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id, true);
    final message = result ? watchlistAddSuccessMessage : watchlistRemoveSuccessMessage;
    emit(MovieWatchlistHasData(result, message));
  }
}
