import 'package:tv_shows/domain/repositories/tv_shows_repository.dart';

class GetTvShowWatchListStatus {
  final TvShowRepository tRepository;

  GetTvShowWatchListStatus(this.tRepository);

  Future<bool> execute(int id) async {
    return tRepository.isAddedToWatchlist(id);
  }
}
