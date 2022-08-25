part of 'movie_watchlist_bloc.dart';

@immutable
abstract class MovieWatchlistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieWatchlistStatusFetched extends MovieWatchlistEvent {
  final int id;

  MovieWatchlistStatusFetched(this.id);

  @override
  List<Object> get props => [id];
}

class MovieSavedToWatchlist extends MovieWatchlistEvent {
  final MovieDetail movie;

  MovieSavedToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class MovieRemovedFromWatchlist extends MovieWatchlistEvent {
  final MovieDetail movie;

  MovieRemovedFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
