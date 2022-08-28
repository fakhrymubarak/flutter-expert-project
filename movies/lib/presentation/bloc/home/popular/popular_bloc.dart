import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final GetPopularMovies getPopularMovies;

  MoviePopularBloc(this.getPopularMovies) : super(PopularEmpty()) {
    on<PopularFetched>((event, emit) async {
      emit(PopularLoading());

      final result = await getPopularMovies.execute();
      result.fold((failure) {
        emit(PopularError(failure.message));
      }, (data) {
        emit(PopularHasData(data));
      });
    });
  }
}
