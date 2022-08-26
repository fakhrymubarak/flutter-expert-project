part of 'popular_bloc.dart';

@immutable
abstract class MoviePopularEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class PopularFetched extends MoviePopularEvent {}
