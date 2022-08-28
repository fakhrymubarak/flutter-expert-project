import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/domain/repositories/tv_shows_repository.dart';

class SearchTvShows {
  final TvShowRepository repository;

  SearchTvShows(this.repository);

  Future<Either<Failure, List<TvShow>>> execute(String query) {
    return repository.searchTvShows(query);
  }
}
