import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/domain/usecases/get_on_air_tv_shows.dart';

part 'on_air_event.dart';
part 'on_air_state.dart';

class TvShowOnAirBloc extends Bloc<TvShowOnAirEvent, TvShowOnAirState> {
  final GetOnAirTvShows getOnAirTvShows;

  TvShowOnAirBloc(this.getOnAirTvShows) : super(OnAirEmpty()) {
    on<OnAirFetched>((event, emit) async {
      emit(OnAirLoading());

      final result = await getOnAirTvShows.execute();
      result.fold((failure) {
        emit(OnAirError(failure.message));
      }, (data) {
        emit(OnAirHasData(data));
      });
    });
  }
}
