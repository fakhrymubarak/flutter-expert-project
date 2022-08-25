import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/transformers.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  }) : super(MovieDetailLoading()) {
    on<MovieDetailFetched>(
      _fetchMovieDetail,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
  }

  void _fetchMovieDetail(
      MovieDetailFetched event, Emitter<MovieDetailState> emit) async {
    final movieId = event.id;

    emit(MovieDetailLoading());
    final resultDetail = await getMovieDetail.execute(movieId);
    final resultRecommendation = await getMovieRecommendations.execute(movieId);

    resultDetail.fold(
      (failure) {
        emit(MovieDetailError(failure.message, ''));
      },
      (movieDetail) {
        resultRecommendation.fold(
          (failure) {
            emit(MovieDetailError('', failure.message));
          },
          (movieRecommendations) {
            emit(MovieDetailHasData(movieDetail, movieRecommendations));
          },
        );
      },
    );
  }

}
