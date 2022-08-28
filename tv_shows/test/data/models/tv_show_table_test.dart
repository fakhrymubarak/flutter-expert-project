import 'package:flutter_test/flutter_test.dart';
import 'package:tv_shows/data/models/tv_show_table.dart';

void main() {
  final tTvShowTable = TvShowTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTvShowTableJson = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  test('should be a json map', () async {
    final result = tTvShowTable.toJson();
    expect(result, tTvShowTableJson);
  });
}
