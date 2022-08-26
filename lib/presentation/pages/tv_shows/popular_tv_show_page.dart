import 'package:ditonton/presentation/bloc/tv_shows/home/popular/popular_bloc.dart';
import 'package:ditonton/presentation/widgets/item_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-show';

  @override
  _PopularTvShowsPageState createState() => _PopularTvShowsPageState();
}

class _PopularTvShowsPageState extends State<PopularTvShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context..read<TvShowPopularBloc>().add(PopularFetched()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvShowPopularBloc, TvShowPopularState>(
          builder: (context, state) {
            if (state is PopularLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularHasData) {
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
            } else if (state is PopularError) {
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
