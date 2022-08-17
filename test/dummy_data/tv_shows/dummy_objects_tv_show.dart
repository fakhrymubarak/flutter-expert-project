import 'package:ditonton/data/models/tv_shows/tv_show_table.dart';
import 'package:ditonton/data/models/watchlist/watchlist_table.dart';
import 'package:ditonton/domain/entities/tv_show.dart';

final testTvShowCache = TvShowTable(
  id: 203599,
  overview: "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
  posterPath: "/qo6y0XvSBlKM3XCbYVdcR3a6qyQ.jpg",
  title: "Scoop",
);

final testMovieCacheMap = {
  'id': 557,
  'overview':
  'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  'title': 'Spider-Man',
};

final testTvShowCacheMap = {
  'id': 203599,
  'overview': "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
  'posterPath': "/qo6y0XvSBlKM3XCbYVdcR3a6qyQ.jpg",
  'title': "Scoop",
};


final testTvShowFromCache = TvShow.watchlist(
  id: 203599,
  overview: "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
  posterPath: "/qo6y0XvSBlKM3XCbYVdcR3a6qyQ.jpg",
  name: "Scoop",
);

final testWatchlistMovieTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  type: 1,
);

final testWatchlistTvShowTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  type: 2,
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};
