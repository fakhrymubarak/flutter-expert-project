part of 'now_playing_bloc.dart';

@immutable
abstract class MovieNowPlayingEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class NowPlayingFetched extends MovieNowPlayingEvent {}
