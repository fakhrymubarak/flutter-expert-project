import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_shows/domain/entities/tv_show_detail.dart';
import 'package:tv_shows/domain/repositories/tv_shows_repository.dart';

class RemoveTvShowWatchlist {
  final TvShowRepository repository;

  RemoveTvShowWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvShowDetail tvShow) {
    return repository.removeWatchlist(tvShow);
  }
}
