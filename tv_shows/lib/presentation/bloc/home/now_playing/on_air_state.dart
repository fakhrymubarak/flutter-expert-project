part of 'on_air_bloc.dart';

@immutable
abstract class TvShowOnAirState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnAirEmpty extends TvShowOnAirState {}

class OnAirLoading extends TvShowOnAirState {}

class OnAirError extends TvShowOnAirState {
  final String message;

  OnAirError(this.message);

  @override
  List<Object> get props => [message];
}

class OnAirHasData extends TvShowOnAirState {
  final List<TvShow> tvShows;

  OnAirHasData(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

