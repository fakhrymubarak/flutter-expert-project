import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';

part 'now_playing_event.dart';
part 'now_playing_state.dart';

class MovieNowPlayingBloc extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  MovieNowPlayingBloc(this.getNowPlayingMovies) : super(NowPlayingEmpty()) {
    on<NowPlayingFetched>((event, emit) async {
      emit(NowPlayingLoading());

      final result = await getNowPlayingMovies.execute();
      result.fold((failure) {
        emit(NowPlayingError(failure.message));
      }, (data) {
        emit(NowPlayingHasData(data));
      });
    });
  }
}
