part of 'movie_detail_bloc.dart';

@immutable
abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class MovieDetailFetched extends MovieDetailEvent {
  final int id;

  MovieDetailFetched(this.id);

  @override
  List<Object> get props => [id];
}
