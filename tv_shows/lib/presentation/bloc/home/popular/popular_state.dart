part of 'popular_bloc.dart';

@immutable
abstract class TvShowPopularState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularEmpty extends TvShowPopularState {}

class PopularLoading extends TvShowPopularState {}

class PopularError extends TvShowPopularState {
  final String message;

  PopularError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularHasData extends TvShowPopularState {
  final List<TvShow> tvShows;

  PopularHasData(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

