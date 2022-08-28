import 'package:watchlist/data/models/watchlist_table.dart';

final testWatchlistMovieTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  type: 1,
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testWatchlistTvShowTable = WatchlistTable(
  id: 1,
  title: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
  type: 1,
);

final testTvShowMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'name',
};
