import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/presentation/bloc/tv_shows/details/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_shows/tv_show_watchlist/tv_show_watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvShowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;

  TvShowDetailPage({required this.id});

  @override
  _TvShowDetailPageState createState() => _TvShowDetailPageState();
}

class _TvShowDetailPageState extends State<TvShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
        ..read<TvShowDetailBloc>().add(TvShowDetailFetched(widget.id))
        ..read<TvShowWatchlistBloc>()
            .add(TvShowWatchlistStatusFetched(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
        builder: (context, state) {
          if (state is TvShowDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvShowDetailHasData) {
            return SafeArea(
              child: DetailContent(
                state.tvShowDetail,
                state.tvShowRecommendations,
              ),
            );
          } else if (state is TvShowDetailError) {
            return Text(state.messageDetailError);
          } else {
            debugPrint(state.toString());
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvShowDetail tvShow;
  final List<TvShow> recommendations;

  DetailContent(this.tvShow, this.recommendations);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvShow.name,
                              style: kHeading5,
                            ),
                            _buildWatchlistButton(),
                            Text(
                              _showGenres(tvShow.genres),
                            ),
                            Text(
                              _showDuration((tvShow.episodeRunTime != null &&
                                      tvShow.episodeRunTime!.isNotEmpty)
                                  ? tvShow.episodeRunTime!
                                      .reduce((a, b) => a + b)
                                  : 0),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvShow.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvShow.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvShow.overview,
                            ),
                            (tvShow.seasons != null &&
                                    tvShow.seasons!.isNotEmpty)
                                ? _buildSeasonsSection(tvShow.seasons!)
                                : SizedBox(),
                            SizedBox(height: 16),
                            (recommendations.isNotEmpty)
                                ? _buildRecommendationsSection()
                                : SizedBox(),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _buildSeasonsSection(List<Season> seasons) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Season',
              style: kHeading6,
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final season = seasons[index];
                return Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Card(
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 16 + 80 + 16,
                            bottom: 8,
                            right: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                season.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kHeading6,
                              ),
                              SizedBox(height: 16),
                              Text(
                                season.overview,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 16,
                        bottom: 16,
                      ),
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: '$BASE_IMAGE_URL${season.posterPath}',
                          width: 80,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ],
                );
              },
              itemCount: seasons.length,
            ),
          ],
        ),
      );

  Widget _buildRecommendationsSection() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Recommendations',
              style: kHeading6,
            ),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final tvShow = recommendations[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          TvShowDetailPage.ROUTE_NAME,
                          arguments: tvShow.id,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: recommendations.length,
              ),
            ),
          ],
        ),
      );

  Widget _buildWatchlistButton() =>
      BlocConsumer<TvShowWatchlistBloc, TvShowWatchlistState>(
        listener: ((context, state) {
          if (state is! TvShowWatchlistStatusData) return;
          final message = state.message;
          if (message == TvShowWatchlistBloc.watchlistAddSuccessMessage ||
              message == TvShowWatchlistBloc.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(message),
                  );
                });
          }
        }),
        builder: (context, state) {
          return (state is! TvShowWatchlistStatusData)
              ? Container()
              : ElevatedButton(
                  onPressed: () async {
                    context.read<TvShowWatchlistBloc>().add((!state.isWatchlist)
                        ? TvShowSavedToWatchlist(tvShow)
                        : TvShowRemovedFromWatchlist(tvShow));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      state.isWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                      Text('Watchlist'),
                    ],
                  ),
                );
        },
      );
}
