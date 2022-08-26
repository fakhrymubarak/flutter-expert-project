part of 'now_playing_bloc.dart';

@immutable
abstract class MovieNowPlayingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NowPlayingEmpty extends MovieNowPlayingState {}

class NowPlayingLoading extends MovieNowPlayingState {}

class NowPlayingError extends MovieNowPlayingState {
  final String message;

  NowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingHasData extends MovieNowPlayingState {
  final List<Movie> movies;

  NowPlayingHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

