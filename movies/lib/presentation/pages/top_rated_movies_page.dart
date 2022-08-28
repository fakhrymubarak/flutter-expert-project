import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/home/top_rated/top_rated_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
        ..read<MovieTopRatedBloc>().add(TopRatedFetched());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
          builder: (context, state) {
            if (state is TopRatedLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedHasData) {
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
