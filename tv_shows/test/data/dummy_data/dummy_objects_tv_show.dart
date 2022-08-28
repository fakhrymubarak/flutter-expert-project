import 'package:tv_shows/data/models/tv_show_table.dart';
import 'package:tv_shows/domain/entities/genre.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/domain/entities/tv_show_detail.dart';
import 'package:watchlist/data/models/watchlist_table.dart';


final testTvShowCache = TvShowTable(
  id: 203599,
  overview:
      "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
  posterPath: "/qo6y0XvSBlKM3XCbYVdcR3a6qyQ.jpg",
  title: "Scoop",
);

final testTvShowCacheMap = {
  'id': 203599,
  'overview':
      "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
  'posterPath': "/qo6y0XvSBlKM3XCbYVdcR3a6qyQ.jpg",
  'title': "Scoop",
};

final testTvShowFromCache = TvShow.watchlist(
  id: 203599,
  overview:
      "Scoop is a comprehensive information programme of Television Broadcasts Limited.\n\nThe content of the program is mainly based on entertainment news and personal follow-up of the artists, and will also be interspersed with the latest trends of TVB dramas and artists. Some entertainment news content clips will be rebroadcast on the next day's \"Entertainment Live\".\n\nThis program will be broadcast on Jade Channel from 19:30-20:00 (Hong Kong time) from June 6, 2005, and will be broadcast every day from March 3, 2019, and will be broadcast on myTV (later myTV SUPER) to provide \"Program Review\".",
  posterPath: "/qo6y0XvSBlKM3XCbYVdcR3a6qyQ.jpg",
  name: "Scoop",
);

final testWatchlistTvShow = TvShow.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

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

final testTvShow = TvShow(
    backdropPath: "/vfWdZYGR5505zrCdgTHteFyARu3.jpg",
    firstAirDate: "2022-03-30",
    genreIds: [10759, 10765, 9648],
    id: 92749,
    name: "Moon Knight",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Moon Knight",
    overview:
    "When Steven Grant, a mild-mannered gift-shop employee, becomes plagued with blackouts and memories of another life, he discovers he has dissociative identity disorder and shares a body with mercenary Marc Spector. As Steven/Marc's enemies converge upon them, they must navigate their complex identities while thrust into a deadly mystery among the powerful gods of Egypt.",
    popularity: 543.452,
    posterPath: "/YksR65as1ppF2N48TJAh2PLamX.jpg",
    voteAverage: 8.1,
    voteCount: 1375);

final tQuery = 'spiderman';

final testTvShowDetail = TvShowDetail(
  adult: false,
  backdropPath: "backdropPath",
  createdBy: [
    Author(
        id: 1,
        creditId: "creditId",
        name: "name",
        gender: 2,
        profilePath: "/profilePath")
  ],
  episodeRunTime: [1],
  firstAirDate: DateTime(2020, 12, 31),
  genres: [Genre(id: 1, name: "name")],
  homepage: "homepage",
  id: 1,
  inProduction: false,
  languages: ["languages"],
  lastAirDate: DateTime(2020, 12, 31),
  lastEpisodeToAir: Episode(
      airDate: DateTime(2020, 12, 31),
      episodeNumber: 5,
      id: 1,
      name: "name",
      overview: "overview",
      productionCode: "productionCode",
      runtime: 1,
      seasonNumber: 1,
      showId: 1,
      stillPath: "stillPath",
      voteAverage: 1,
      voteCount: 1),
  name: "name",
  nextEpisodeToAir: Episode(
      airDate: DateTime(2020, 12, 31),
      episodeNumber: 5,
      id: 1,
      name: "name",
      overview: "overview",
      productionCode: "productionCode",
      runtime: 1,
      seasonNumber: 1,
      showId: 1,
      stillPath: "stillPath",
      voteAverage: 1,
      voteCount: 1),
  networks: [
    Network(
        id: 1,
        name: "name",
        logoPath: "logoPath",
        originCountry: "originCountry")
  ],
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  originCountry: ["en"],
  originalLanguage: "originalLanguage",
  originalName: "originalName",
  overview: "overview",
  popularity: 1,
  posterPath: "posterPath",
  productionCompanies: [
    Network(
        id: 1,
        name: "name",
        logoPath: "logoPath",
        originCountry: "originCountry")
  ],
  seasons: [
    Season(
        airDate: DateTime(2020, 12, 31),
        episodeCount: 1,
        id: 1,
        name: "name",
        overview: "overview",
        posterPath: "posterPath",
        seasonNumber: 1)
  ],
  status: "status",
  tagline: "tagline",
  type: "type",
  voteAverage: 1,
  voteCount: 1,
);
