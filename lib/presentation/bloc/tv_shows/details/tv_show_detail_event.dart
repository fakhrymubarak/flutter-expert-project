part of 'tv_show_detail_bloc.dart';

@immutable
abstract class TvShowDetailEvent extends Equatable {
  const TvShowDetailEvent();

  @override
  List<Object> get props => [];
}

class TvShowDetailFetched extends TvShowDetailEvent {
  final int id;

  TvShowDetailFetched(this.id);

  @override
  List<Object> get props => [id];
}
