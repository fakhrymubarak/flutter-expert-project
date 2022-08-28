import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_shows/presentation/bloc/tv_show_watchlist/tv_show_watchlist_bloc.dart';

class WatchlistTvShowsPage extends StatefulWidget {

  @override
  _WatchlistTvShowsPageState createState() => _WatchlistTvShowsPageState();
}

class _WatchlistTvShowsPageState extends State<WatchlistTvShowsPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TvShowWatchlistBloc>().add(TvShowWatchlistFetched()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<TvShowWatchlistBloc>().add(TvShowWatchlistFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvShowWatchlistBloc, TvShowWatchlistState>(
          builder: (context, state) {
            if (state is TvShowWatchlistLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvShowWatchlistHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = state.tvShows[index];
                  return ItemCard(
                    id: tvShow.id,
                    title: tvShow.name ?? "-",
                    overview: tvShow.overview ?? "-",
                    posterPath: tvShow.posterPath ?? "",
                    isMovie: false,
                  );
                },
                itemCount: state.tvShows.length,
              );
            } else if (state is TvShowWatchlistError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else
              return Text('Failed');
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
