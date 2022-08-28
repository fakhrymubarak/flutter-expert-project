part of 'tv_show_watchlist_bloc.dart';

@immutable
abstract class TvShowWatchlistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvShowWatchlistFetched extends TvShowWatchlistEvent {}

class TvShowWatchlistStatusFetched extends TvShowWatchlistEvent {
  final int id;

  TvShowWatchlistStatusFetched(this.id);

  @override
  List<Object> get props => [id];
}

class TvShowSavedToWatchlist extends TvShowWatchlistEvent {
  final TvShowDetail tvShow;

  TvShowSavedToWatchlist(this.tvShow);

  @override
  List<Object> get props => [tvShow];
}

class TvShowRemovedFromWatchlist extends TvShowWatchlistEvent {
  final TvShowDetail tvShow;

  TvShowRemovedFromWatchlist(this.tvShow);

  @override
  List<Object> get props => [tvShow];
}
