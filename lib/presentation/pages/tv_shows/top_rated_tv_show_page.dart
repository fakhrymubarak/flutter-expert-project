import 'package:ditonton/presentation/bloc/tv_shows/home/top_rated/top_rated_bloc.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-show';

  @override
  _TopRatedTvShowsPageState createState() => _TopRatedTvShowsPageState();
}

class _TopRatedTvShowsPageState extends State<TopRatedTvShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
        ..read<TvShowTopRatedBloc>().add(TopRatedFetched());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvShowTopRatedBloc, TvShowTopRatedState>(
          builder: (context, state) {
            if (state is TopRatedLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedHasData) {
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
            } else if (state is TopRatedError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Text('Failed');
            }
          },
        ),
      ),
    );
  }
}
