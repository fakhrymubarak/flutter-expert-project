import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_shows/domain/entities/tv_show_detail.dart';
import 'package:tv_shows/domain/repositories/tv_shows_repository.dart';

class GetTvShowDetail {
  final TvShowRepository repository;

  GetTvShowDetail(this.repository);

  Future<Either<Failure, TvShowDetail>> execute(int id) {
    return repository.getTvShowDetail(id);
  }
}
