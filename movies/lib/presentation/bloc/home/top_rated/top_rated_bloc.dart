import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';

class MovieTopRatedBloc extends Bloc<MovieTopRatedEvent, MovieTopRatedState> {
  final GetTopRatedMovies getTopRatedMovies;

  MovieTopRatedBloc(this.getTopRatedMovies) : super(TopRatedEmpty()) {
    on<TopRatedFetched>((event, emit) async {
      emit(TopRatedLoading());

      final result = await getTopRatedMovies.execute();
      result.fold((failure) {
        emit(TopRatedError(failure.message));
      }, (data) {
        emit(TopRatedHasData(data));
      });
    });
  }
}
