import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_on_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_top_rated_tv_shows.dart';
import 'package:flutter/material.dart';

class TvShowListNotifier extends ChangeNotifier {
  var _onAirTvShow = <TvShow>[];

  List<TvShow> get onAirTvShow => _onAirTvShow;

  RequestState _onAirTvShows = RequestState.Empty;

  RequestState get onAirState => _onAirTvShows;

  var _popularTvShow = <TvShow>[];

  List<TvShow> get popularTvShow => _popularTvShow;

  RequestState _popularTvShows = RequestState.Empty;

  RequestState get popularState => _popularTvShows;

  var _topRatedTvShow = <TvShow>[];

  List<TvShow> get topRatedTvShow => _topRatedTvShow;

  RequestState _topRatedTvShows = RequestState.Empty;

  RequestState get topRatedState => _topRatedTvShows;

  String _message = '';

  String get message => _message;

  TvShowListNotifier({
    required this.getOnAirTvShows,
    required this.getPopularTvShows,
    required this.getTopRatedTvShows,
  });

  final GetOnAirTvShows getOnAirTvShows;
  final GetPopularTvShows getPopularTvShows;
  final GetTopRatedTvShows getTopRatedTvShows;

  Future<void> fetchOnAirTvShows() async {
    _onAirTvShows = RequestState.Loading;
    notifyListeners();

    final result = await getOnAirTvShows.execute();
    result.fold(
      (failure) {
        _onAirTvShows = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShows) {
        _onAirTvShows = RequestState.Loaded;
        _onAirTvShow = tvShows;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvShows() async {
    _popularTvShows = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvShows.execute();
    result.fold(
      (failure) {
        _popularTvShows = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShows) {
        _popularTvShows = RequestState.Loaded;
        _popularTvShow = tvShows;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvShows() async {
    _topRatedTvShows = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvShows.execute();
    result.fold(
      (failure) {
        _topRatedTvShows = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShows) {
        _topRatedTvShows = RequestState.Loaded;
        _topRatedTvShow = tvShows;
        notifyListeners();
      },
    );
  }
}
