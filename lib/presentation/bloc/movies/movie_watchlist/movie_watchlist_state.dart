part of 'movie_watchlist_bloc.dart';

@immutable
abstract class MovieWatchlistState extends Equatable {}

class MovieWatchlistInitial extends MovieWatchlistState {
  @override
  List<Object?> get props => [];
}

class MovieWatchlistHasData extends MovieWatchlistState {
  final bool isWishlist;
  final String message;

  MovieWatchlistHasData(this.isWishlist, this.message);

  @override
  List<Object> get props => [isWishlist, message];
}
