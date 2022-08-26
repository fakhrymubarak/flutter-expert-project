import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/common/ssl_pinning.dart';
import 'package:ditonton/data/datasources/local/db/database_helper.dart';
import 'package:ditonton/data/datasources/local/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/local/tv_show_local_data_source.dart';
import 'package:ditonton/data/datasources/local/watchlist_local_data_source.dart';
import 'package:ditonton/data/datasources/remote/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/remote/tv_show_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_shows_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvShowRepository,
  TvShowRemoteDataSource,
  TvShowLocalDataSource,
  WatchlistLocalDataSource,
  DatabaseHelper,
  NetworkInfo
], customMocks: [
  MockSpec<ApiIOClient>(as: #MockApiIOClient)
])
void main() {}
