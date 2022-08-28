import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:movies/data/datasources/local/db/movie_database_helper.dart';
import 'package:movies/data/datasources/local/movie_local_data_source.dart';
import 'package:movies/data/datasources/remote/movie_remote_data_source.dart';
import 'package:movies/domain/repositories/movie_repository.dart';
import 'package:watchlist/watchlist.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  WatchlistLocalDataSource,
  MovieDatabaseHelper,
  NetworkInfo
], customMocks: [
  MockSpec<ApiIOClient>(as: #MockApiIOClient)
])
void main() {}
