import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/domain/usecases/get_top_rated_tv_shows.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';

class TvShowTopRatedBloc extends Bloc<TvShowTopRatedEvent, TvShowTopRatedState> {
  final GetTopRatedTvShows getTopRatedTvShows;

  TvShowTopRatedBloc(this.getTopRatedTvShows) : super(TopRatedEmpty()) {
    on<TopRatedFetched>((event, emit) async {
      emit(TopRatedLoading());

      final result = await getTopRatedTvShows.execute();
      result.fold((failure) {
        emit(TopRatedError(failure.message));
      }, (data) {
        emit(TopRatedHasData(data));
      });
    });
  }
}
