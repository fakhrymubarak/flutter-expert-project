part of 'search_tv_shows_bloc.dart';

@immutable
abstract class SearchTvShowsEvent extends Equatable {
  const SearchTvShowsEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchTvShowsEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}