import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_shows/presentation/bloc/search/search_tv_shows_bloc.dart';

class SearchTvShowPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv-show';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Tv Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchTvShowsBloc>().add(OnQueryChanged(query));
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
            BlocBuilder<SearchTvShowsBloc, SearchTvShowsState>(
              builder: (context, state) {
                if (state is SearchTvShowsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchTvShowsHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tvShow = result[index];
                        return ItemCard(
                          id: tvShow.id,
                          title: tvShow.name ?? "-",
                          overview: tvShow.overview ?? "-",
                          posterPath: tvShow.posterPath ?? "",
                          isMovie: false,
                        );
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
