import 'package:ditonton/data/models/movies/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovieTableJson = {'id': 1, 'title': 'title', 'posterPath': 'posterPath', 'overview': 'overview'};

  test('should be a json map', () async {
    final result = tMovieTable.toJson();
    expect(result, tMovieTableJson);
  });
}
