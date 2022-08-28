import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/transformers.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/domain/entities/tv_show_detail.dart';
import 'package:tv_shows/domain/usecases/get_recommendation_tv_show.dart';
import 'package:tv_shows/domain/usecases/get_tv_show_detail.dart';

part 'tv_show_detail_event.dart';
part 'tv_show_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {

  final GetTvShowDetail getTvShowDetail;
  final GetTvShowRecommendations getTvShowRecommendations;

  TvShowDetailBloc({
    required this.getTvShowDetail,
    required this.getTvShowRecommendations,
  }) : super(TvShowDetailLoading()) {
    on<TvShowDetailFetched>(
      _fetchTvShowDetail,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
  }

  void _fetchTvShowDetail(
      TvShowDetailFetched event, Emitter<TvShowDetailState> emit) async {
    final movieId = event.id;

    emit(TvShowDetailLoading());
    final resultDetail = await getTvShowDetail.execute(movieId);
    final resultRecommendation = await getTvShowRecommendations.execute(movieId);

    resultDetail.fold(
      (failure) {
        emit(TvShowDetailError(failure.message, ''));
      },
      (movieDetail) {
        resultRecommendation.fold(
          (failure) {
            emit(TvShowDetailError('', failure.message));
          },
          (movieRecommendations) {
            emit(TvShowDetailHasData(movieDetail, movieRecommendations));
          },
        );
      },
    );
  }

}
