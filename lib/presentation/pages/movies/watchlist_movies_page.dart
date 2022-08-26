import 'package:core/core.dart';
import 'package:ditonton/presentation/bloc/movies/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlists-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
    context
      .read<MovieWatchlistBloc>().add(MovieWatchlistFetched()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context
        .read<MovieWatchlistBloc>().add(MovieWatchlistFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:               BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
        builder: (context, state) {
          if (state is MovieWatchlistLoading) {
            return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieWatchlistHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return ItemCard(
                    id: movie.id,
                    title: movie.title ?? "-",
                    overview: movie.overview ?? "-",
                    posterPath: movie.posterPath ?? "",
                    isMovie: true,
                  );
                },
                itemCount: state.movies.length,
              );
            } else if (state is MovieWatchlistError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else return Text('Failed');
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
