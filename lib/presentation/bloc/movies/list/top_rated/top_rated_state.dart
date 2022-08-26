part of 'top_rated_bloc.dart';

@immutable
abstract class MovieTopRatedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedEmpty extends MovieTopRatedState {}

class TopRatedLoading extends MovieTopRatedState {}

class TopRatedError extends MovieTopRatedState {
  final String message;

  TopRatedError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedHasData extends MovieTopRatedState {
  final List<Movie> movies;

  TopRatedHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

