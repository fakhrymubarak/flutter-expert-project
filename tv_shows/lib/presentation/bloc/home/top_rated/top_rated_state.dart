part of 'top_rated_bloc.dart';

@immutable
abstract class TvShowTopRatedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedEmpty extends TvShowTopRatedState {}

class TopRatedLoading extends TvShowTopRatedState {}

class TopRatedError extends TvShowTopRatedState {
  final String message;

  TopRatedError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedHasData extends TvShowTopRatedState {
  final List<TvShow> tvShows;

  TopRatedHasData(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

