part of 'movie_watchlist_bloc.dart';

@immutable
abstract class MovieWatchlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieWatchlistInitial extends MovieWatchlistState {}

class MovieWatchlistStatusData extends MovieWatchlistState {
  final bool isWatchlist;
  final String message;

  MovieWatchlistStatusData(this.isWatchlist, this.message);

  @override
  List<Object> get props => [isWatchlist, message];
}

class MovieWatchlistLoading extends MovieWatchlistState {}

class MovieWatchlistError extends MovieWatchlistState {
  final String message;

  MovieWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistHasData extends MovieWatchlistState {
  final List<Movie> movies;

  MovieWatchlistHasData(this.movies);

  @override
  List<Object> get props => [movies];
}
