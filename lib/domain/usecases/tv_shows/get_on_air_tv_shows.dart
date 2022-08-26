import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/repositories/tv_shows_repository.dart';

class GetOnAirTvShows {
  final TvShowRepository repository;

  GetOnAirTvShows(this.repository);

  Future<Either<Failure, List<TvShow>>> execute() {
    return repository.getOnAirTvShows();
  }
}
