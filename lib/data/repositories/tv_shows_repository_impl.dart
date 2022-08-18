import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/local/tv_show_local_data_source.dart';
import 'package:ditonton/data/datasources/local/watchlist_local_data_source.dart';
import 'package:ditonton/data/datasources/remote/tv_show_remote_data_source.dart';
import 'package:ditonton/data/models/tv_shows/tv_show_table.dart';
import 'package:ditonton/data/models/watchlist/watchlist_table.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/domain/repositories/tv_shows_repository.dart';

class TvShowRepositoryImpl implements TvShowRepository {
  final TvShowRemoteDataSource remoteDataSource;
  final TvShowLocalDataSource localDataSource;
  final WatchlistLocalDataSource wLocalDataSource;
  final NetworkInfo networkInfo;

  TvShowRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.wLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TvShow>>> getOnAirTvShows() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getOnAirTvShows();
        localDataSource.cacheOnAirTvShow(
            result.map((tvShow) => TvShowTable.fromDTO(tvShow)).toList());
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      }
    } else {}
    try {
      final result = await localDataSource.getCachedOnAirTvShow();
      return Right(result.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> getPopularTvShows() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPopularTvShows();
        localDataSource.cachePopularTvShow(
            result.map((tvShow) => TvShowTable.fromDTO(tvShow)).toList());
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      }
    } else {}
    try {
      final result = await localDataSource.getCachedPopularTvShow();
      return Right(result.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> getTopRatedTvShows() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTopRatedTvShows();
        localDataSource.cacheTopRatedTvShow(
            result.map((tvShow) => TvShowTable.fromDTO(tvShow)).toList());
        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      }
    } else {}
    try {
      final result = await localDataSource.getCachedTopRatedTvShow();
      return Right(result.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TvShowDetail>> getTvShowDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvShowDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TvShow>>> getTvShowRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTvShowRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvShowDetail tvShow) async {
    try {
      final result =
      await wLocalDataSource.insertWatchlist(WatchlistTable.fromTvShowEntity(tvShow));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvShowDetail tvShow) async {
    try {
      final result =
      await wLocalDataSource.removeWatchlist(WatchlistTable.fromTvShowEntity(tvShow));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await wLocalDataSource.getTvShowById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TvShow>>> getWatchlistTvShow() async {
    final result = await wLocalDataSource.getWatchlistTvShow();
    return Right(result.map((data) => data.toTvShowEntity()).toList());
  }
}
