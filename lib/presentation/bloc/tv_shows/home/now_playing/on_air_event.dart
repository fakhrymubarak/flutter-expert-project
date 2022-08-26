part of 'on_air_bloc.dart';

@immutable
abstract class TvShowOnAirEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class OnAirFetched extends TvShowOnAirEvent {}
