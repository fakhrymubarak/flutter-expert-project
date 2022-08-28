import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_shows/domain/entities/tv_show_detail.dart';
import 'package:tv_shows/domain/repositories/tv_shows_repository.dart';

class SaveTvShowWatchlist {
  final TvShowRepository repository;

  SaveTvShowWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvShowDetail tvShow) {
    return repository.saveWatchlist(tvShow);
  }
}
