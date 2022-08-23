import 'package:bloc/bloc.dart';
import 'package:ditonton/common/bloc_utils.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/tv_shows/search_tv_shows.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_tv_shows_event.dart';
part 'search_tv_shows_state.dart';

class SearchTvShowsBloc extends Bloc<SearchTvShowsEvent, SearchTvShowsState> {
  final SearchTvShows _searchTvShows;

  SearchTvShowsBloc(this._searchTvShows) : super(SearchTvShowsEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchTvShowsLoading());
      final result = await _searchTvShows.execute(query);

      result.fold(
            (failure) {
          emit(SearchTvShowsError(failure.message));
        },
            (data) {
          emit(SearchTvShowsHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
