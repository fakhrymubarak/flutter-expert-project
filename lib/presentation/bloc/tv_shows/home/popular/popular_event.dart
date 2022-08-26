part of 'popular_bloc.dart';

@immutable
abstract class TvShowPopularEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class PopularFetched extends TvShowPopularEvent {}
