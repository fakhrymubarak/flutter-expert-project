import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_popular_tv_shows.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
