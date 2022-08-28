part of 'tv_show_watchlist_bloc.dart';

@immutable
abstract class TvShowWatchlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvShowWatchlistInitial extends TvShowWatchlistState {}

class TvShowWatchlistStatusData extends TvShowWatchlistState {
  final bool isWatchlist;
  final String message;

  TvShowWatchlistStatusData(this.isWatchlist, this.message);

  @override
  List<Object> get props => [isWatchlist, message];
}

class TvShowWatchlistLoading extends TvShowWatchlistState {}

class TvShowWatchlistError extends TvShowWatchlistState {
  final String message;

  TvShowWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class TvShowWatchlistHasData extends TvShowWatchlistState {
  final List<TvShow> tvShows;

  TvShowWatchlistHasData(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}
