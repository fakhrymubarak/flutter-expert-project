import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/utils/firebase_options.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/movies.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows/tv_shows.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Movie Bloc
        BlocProvider(create: (_) => di.locator<MovieNowPlayingBloc>()),
        BlocProvider(create: (_) => di.locator<MoviePopularBloc>()),
        BlocProvider(create: (_) => di.locator<MovieTopRatedBloc>()),
        BlocProvider(create: (_) => di.locator<SearchMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieWatchlistBloc>()),

        // Tv Show Bloc
        BlocProvider(create: (_) => di.locator<TvShowOnAirBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowPopularBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowTopRatedBloc>()),
        BlocProvider(create: (_) => di.locator<SearchTvShowsBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowWatchlistBloc>()),
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
            // tv shows
            case tvShowHomeRoute:
              return MaterialPageRoute(builder: (_) => HomeTvShowPage());
            case tvShowPopularRoute:
              return MaterialPageRoute(builder: (_) => PopularTvShowsPage());
            case tvShowTopRatedRoute:
              return MaterialPageRoute(builder: (_) => TopRatedTvShowsPage());
            case tvShowSearchRoute:
              return CupertinoPageRoute(builder: (_) => SearchTvShowPage());
            case tvShowWatchlistRoute:
              return MaterialPageRoute(builder: (_) => WatchlistTvShowsPage());
            case tvShowDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvShowDetailPage(id: id),
                settings: settings,
              );

            // movies
            case movieHomeRoute:
              return CupertinoPageRoute(builder: (_) => HomeMoviePage());
            case moviePopularRoute:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case movieTopRatedRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case movieSearchRoute:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case movieWatchlistRoute:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case movieDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );

            // about
            case aboutRoute:
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
