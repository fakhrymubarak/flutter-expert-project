import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/search/search_movies_bloc.dart';

class SearchMoviePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchMoviesBloc>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
              builder: (context, state) {
                if (state is SearchMoviesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchMoviesHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = result[index];
                        return ItemCard(
                          id: movie.id,
                          title: movie.title ?? "-",
                          overview: movie.overview ?? "-",
                          posterPath: movie.posterPath ?? "",
                          isMovie: true,
                        );
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchMoviesError){
                  return Text(state.message);
                }else {
                  return Expanded(child: Container());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
