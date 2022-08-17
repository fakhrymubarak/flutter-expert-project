import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_on_air_tv_shows.dart';
import 'package:flutter/material.dart';

class TvShowListNotifier extends ChangeNotifier {
  var _onAirTvShow = <TvShow>[];
  List<TvShow> get onAirTvShow => _onAirTvShow;

  RequestState _onAirTvShows = RequestState.Empty;
  RequestState get onAirState => _onAirTvShows;

  String _message = '';
  String get message => _message;

  TvShowListNotifier({
    required this.getOnAirTvShows,
  });

  final GetOnAirTvShows getOnAirTvShows;

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
}
