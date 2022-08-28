import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/domain/usecases/get_popular_tv_shows.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class TvShowPopularBloc extends Bloc<TvShowPopularEvent, TvShowPopularState> {
  final GetPopularTvShows getPopularTvShows;

  TvShowPopularBloc(this.getPopularTvShows) : super(PopularEmpty()) {
    on<PopularFetched>((event, emit) async {
      emit(PopularLoading());

      final result = await getPopularTvShows.execute();
      result.fold((failure) {
        emit(PopularError(failure.message));
      }, (data) {
        emit(PopularHasData(data));
      });
    });
  }
}
