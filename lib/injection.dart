import 'package:core/core.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:movies/movies.dart';
import 'package:tv_shows/tv_shows.dart';
import 'package:watchlist/data/datasources/db/watchlist_database_helper.dart';
import 'package:watchlist/watchlist.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(() => MovieNowPlayingBloc(locator()));
  locator.registerFactory(() => MoviePopularBloc(locator()));
  locator.registerFactory(() => MovieTopRatedBloc(locator()));
  locator.registerFactory(() => SearchMoviesBloc(locator()));
  locator.registerFactory(() => MovieDetailBloc(
        getMovieDetail: locator(),
        getMovieRecommendations: locator(),
      ));
  locator.registerFactory(() => MovieWatchlistBloc(
        getWatchListStatus: locator(),
        getWatchlistMovies: locator(),
        removeWatchlist: locator(),
        saveWatchlist: locator(),
      ));

  locator.registerFactory(() => TvShowOnAirBloc(locator()));
  locator.registerFactory(() => TvShowPopularBloc(locator()));
  locator.registerFactory(() => TvShowTopRatedBloc(locator()));
  locator.registerFactory(() => SearchTvShowsBloc(locator()));
  locator.registerFactory(() => TvShowDetailBloc(
        getTvShowDetail: locator(),
        getTvShowRecommendations: locator(),
      ));
  locator.registerFactory(() => TvShowWatchlistBloc(
        getWatchListStatus: locator(),
        getWatchlistTvShows: locator(),
        removeWatchlist: locator(),
        saveWatchlist: locator(),
      ));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));

  locator.registerLazySingleton(() => GetMovieWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetOnAirTvShows(locator()));
  locator.registerLazySingleton(() => GetPopularTvShows(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvShows(locator()));
  locator.registerLazySingleton(() => GetTvShowDetail(locator()));
  locator.registerLazySingleton(() => GetTvShowRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvShows(locator()));

  locator.registerLazySingleton(() => GetTvShowWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveTvShowWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvShowWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvShows(locator()));


  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
        wLocalDataSource: locator(),
        networkInfo: locator()),
  );

  locator.registerLazySingleton<TvShowRepository>(
    () => TvShowRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      wLocalDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<TvShowRemoteDataSource>(
      () => TvShowRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvShowLocalDataSource>(
      () => TvShowLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<WatchlistLocalDataSource>(
      () => WatchlistLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<MovieDatabaseHelper>(() => MovieDatabaseHelper());
  locator.registerLazySingleton<TvShowDatabaseHelper>(() => TvShowDatabaseHelper());
  locator.registerLazySingleton<WatchlistDatabaseHelper>(() => WatchlistDatabaseHelper());

  // network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // external
  locator.registerLazySingleton(() => ApiIOClient());
  locator.registerLazySingleton(() => DataConnectionChecker());
}
