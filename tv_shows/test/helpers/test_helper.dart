import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:tv_shows/data/datasources/local/db/tv_show_database_helper.dart';
import 'package:tv_shows/data/datasources/local/tv_show_local_data_source.dart';
import 'package:tv_shows/data/datasources/remote/tv_show_remote_data_source.dart';
import 'package:tv_shows/domain/repositories/tv_shows_repository.dart';
import 'package:watchlist/watchlist.dart';

@GenerateMocks([
  TvShowRepository,
  TvShowRemoteDataSource,
  TvShowLocalDataSource,
  WatchlistLocalDataSource,
  TvShowDatabaseHelper,
  NetworkInfo
], customMocks: [
  MockSpec<ApiIOClient>(as: #MockApiIOClient)
])
void main() {}
