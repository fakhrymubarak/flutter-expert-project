import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_shows_repository.dart';

class GetWatchListStatus {
  final MovieRepository mRepository;
  final TvShowRepository tRepository;

  GetWatchListStatus(this.mRepository, this.tRepository);

  Future<bool> execute(int id, bool isMovie) async {
    return isMovie
        ? mRepository.isAddedToWatchlist(id)
        : tRepository.isAddedToWatchlist(id);
  }
}
