import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/injection.dart' as di;
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
import 'package:ditonton/presentation/pages/about/about_page.dart';
import 'package:ditonton/presentation/pages/movies/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movies/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movies/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movies/search_movie_page.dart';
import 'package:ditonton/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/movies/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv_shows/home_tv_show_page.dart';
import 'package:ditonton/presentation/pages/tv_shows/popular_tv_show_page.dart';
import 'package:ditonton/presentation/pages/tv_shows/search_tv_show_page.dart';
import 'package:ditonton/presentation/pages/tv_shows/top_rated_tv_show_page.dart';
import 'package:ditonton/presentation/pages/tv_shows/tv_show_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_shows/watchlist_tv_shows_page.dart';
import 'package:ditonton/presentation/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieNowPlayingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MoviePopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieWatchlistBloc>(),
        ),


        BlocProvider(
          create: (_) => di.locator<TvShowOnAirBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvShowPopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvShowTopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvShowsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvShowDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvShowWatchlistBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: Material(
          child: CustomDrawer(content: HomeTvShowPage()),
        ),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeTvShowPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvShowPage());
            case PopularTvShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => PopularTvShowsPage());
            case TopRatedTvShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TopRatedTvShowsPage());
            case TvShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvShowDetailPage(id: id),
                settings: settings,
              );
            case HomeMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case SearchTvShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvShowPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTvShowsPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvShowsPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
