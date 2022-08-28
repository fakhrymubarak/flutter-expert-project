import 'package:core/utils/ssl_pinning.dart';
import 'package:mockito/annotations.dart';
import 'package:watchlist/data/datasources/db/watchlist_database_helper.dart';

@GenerateMocks([
  WatchlistDatabaseHelper
], customMocks: [
  MockSpec<ApiIOClient>(as: #MockApiIOClient)
])
void main() {}
