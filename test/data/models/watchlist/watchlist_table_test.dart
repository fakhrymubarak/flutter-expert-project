import 'package:ditonton/data/models/watchlist/watchlist_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tWatchlistTable = WatchlistTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    type: 1,
  );

  final tWatchlistTableJson = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
    'type': 1
  };

  test('should be a json map', () async {
    final result = tWatchlistTable.toJson();
    expect(result, tWatchlistTableJson);
  });
}
