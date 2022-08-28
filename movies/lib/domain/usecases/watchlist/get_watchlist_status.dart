import 'package:movies/domain/repositories/movie_repository.dart';

class GetMovieWatchListStatus {
  final MovieRepository mRepository;

  GetMovieWatchListStatus(this.mRepository);

  Future<bool> execute(int id) async {
    return  mRepository.isAddedToWatchlist(id);
  }
}
