import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/local/db/database_helper.dart';
import 'package:ditonton/data/datasources/local/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/local/tv_show_local_data_source.dart';
import 'package:ditonton/data/datasources/local/watchlist_local_data_source.dart';
import 'package:ditonton/data/datasources/remote/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/remote/tv_show_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_shows_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_shows_repository.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movies/search_movies.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_on_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_recommendation_tv_show.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_top_rated_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv_shows/search_tv_shows.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/watchlists/get_watchlist_tv_shows.dart';
import 'package:ditonton/domain/usecases/watchlists/remove_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlists/remove_tv_show_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlists/save_movie_watchlist.dart';
import 'package:ditonton/domain/usecases/watchlists/save_tv_show_watchlist.dart';
import 'package:ditonton/presentation/bloc/movies/details/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/home/now_playing/now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/home/popular/popular_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/home/top_rated/top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/search/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_shows/details/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_shows/home/now_playing/on_air_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_shows/home/popular/popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_shows/home/top_rated/top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_shows/search/search_tv_shows_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_shows/tv_show_watchlist/tv_show_watchlist_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

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
  locator.registerLazySingleton(() => SearchTvShows(locator()));

  locator.registerLazySingleton(() => GetWatchListStatus(locator(), locator()));

  locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => SaveTvShowWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvShowWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvShows(locator()));

  locator.registerLazySingleton(() => GetOnAirTvShows(locator()));
  locator.registerLazySingleton(() => GetPopularTvShows(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvShows(locator()));
  locator.registerLazySingleton(() => GetTvShowDetail(locator()));
  locator.registerLazySingleton(() => GetTvShowRecommendations(locator()));

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
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());
}
