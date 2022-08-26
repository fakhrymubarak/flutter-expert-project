import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_tv_shows.dart';
import 'package:ditonton/domain/usecases/watchlists/remove_tv_show_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlists/save_tv_show_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/transformers.dart';

part 'tv_show_watchlist_event.dart';
part 'tv_show_watchlist_state.dart';

class TvShowWatchlistBloc
    extends Bloc<TvShowWatchlistEvent, TvShowWatchlistState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatus getWatchListStatus;
  final GetWatchlistTvShows getWatchlistTvShows;
  final SaveTvShowWatchlist saveWatchlist;
  final RemoveTvShowWatchlist removeWatchlist;

  TvShowWatchlistBloc({
    required this.getWatchListStatus,
    required this.getWatchlistTvShows,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvShowWatchlistInitial()) {
    on<TvShowWatchlistStatusFetched>(
      _getTvShowWatchlistStatus,
      transformer: (events, mapper) => events.switchMap(mapper),
    );

    on<TvShowWatchlistFetched>(
      _getTvShowWatchlist,
      transformer: (events, mapper) => events.switchMap(mapper),
    );

    on<TvShowSavedToWatchlist>(
      _saveTvShowToWatchlist,
      transformer: (events, mapper) => events.switchMap(mapper),
    );

    on<TvShowRemovedFromWatchlist>(
      _removeTvShowFromWatchlist,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
  }

  void _saveTvShowToWatchlist(
    TvShowSavedToWatchlist event,
    Emitter<TvShowWatchlistState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tvShow);
    await result.fold(
      (failure) async {
        emit(TvShowWatchlistStatusData(false, failure.message));
      },
      (successMessage) async {
        emit(TvShowWatchlistStatusData(true, watchlistAddSuccessMessage));
      },
    );
  }

  void _removeTvShowFromWatchlist(
    TvShowRemovedFromWatchlist event,
    Emitter<TvShowWatchlistState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tvShow);
    await result.fold(
      (failure) async {
        emit(TvShowWatchlistStatusData(true, failure.message));
      },
      (successMessage) async {
        emit(TvShowWatchlistStatusData(false, watchlistRemoveSuccessMessage));
      },
    );
  }

  void _getTvShowWatchlistStatus(
    TvShowWatchlistStatusFetched event,
    Emitter<TvShowWatchlistState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id, true);
    final message =
        result ? watchlistAddSuccessMessage : watchlistRemoveSuccessMessage;
    emit(TvShowWatchlistStatusData(result, message));
  }

  void _getTvShowWatchlist(
    TvShowWatchlistFetched event,
    Emitter<TvShowWatchlistState> emit,
  ) async {
    emit(TvShowWatchlistLoading());
    final result = await getWatchlistTvShows.execute();
    result.fold((failure) {
      emit(TvShowWatchlistError(failure.message));
    }, (data) {
      emit(TvShowWatchlistHasData(data));
    });
  }
}
