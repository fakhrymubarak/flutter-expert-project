part of 'popular_bloc.dart';

@immutable
abstract class MoviePopularState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularEmpty extends MoviePopularState {}

class PopularLoading extends MoviePopularState {}

class PopularError extends MoviePopularState {
  final String message;

  PopularError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularHasData extends MoviePopularState {
  final List<Movie> movies;

  PopularHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

