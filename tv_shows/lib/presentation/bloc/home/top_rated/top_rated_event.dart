part of 'top_rated_bloc.dart';

@immutable
abstract class TvShowTopRatedEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class TopRatedFetched extends TvShowTopRatedEvent {}
