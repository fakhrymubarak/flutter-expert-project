import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/presentation/bloc/home/now_playing/on_air_bloc.dart';
import 'package:tv_shows/presentation/bloc/home/popular/popular_bloc.dart';
import 'package:tv_shows/presentation/bloc/home/top_rated/top_rated_bloc.dart';
import 'package:tv_shows/presentation/pages/search_tv_show_page.dart';

class HomeTvShowPage extends StatefulWidget {

  @override
  _HomeTvShowPageState createState() => _HomeTvShowPageState();
}

class _HomeTvShowPageState extends State<HomeTvShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context
        ..read<TvShowOnAirBloc>().add(OnAirFetched())
        ..read<TvShowPopularBloc>().add(PopularFetched())
        ..read<TvShowTopRatedBloc>().add(TopRatedFetched()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ditonton Tv Show'),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvShowPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'On Air',
                style: kHeading6,
              ),
              BlocBuilder<TvShowOnAirBloc, TvShowOnAirState>(
                  builder: (context, state) {
                if (state is OnAirLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OnAirHasData) {
                  return TvShowList(state.tvShows);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, tvShowPopularRoute),
              ),
              BlocBuilder<TvShowPopularBloc, TvShowPopularState>(
                  builder: (context, state) {
                if (state is PopularLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularHasData) {
                  return TvShowList(state.tvShows);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                    context, tvShowTopRatedRoute),
              ),
              BlocBuilder<TvShowTopRatedBloc, TvShowTopRatedState>(
                builder: (context, state) {
                  if (state is TopRatedLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedHasData) {
                    return TvShowList(state.tvShows);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvShowList extends StatelessWidget {
  final List<TvShow> tvShows;

  TvShowList(this.tvShows);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  tvShowDetailRoute,
                  arguments: tvShow.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
