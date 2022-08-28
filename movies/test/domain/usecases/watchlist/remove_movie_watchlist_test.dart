import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/usecases/watchlist/remove_movie_watchlist.dart';

import '../../../data/dummy_data/dummy_objects_movie.dart';
import '../../../helpers/test_helper.mocks.dart';


void main() {
  late RemoveMovieWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveMovieWatchlist(mockMovieRepository);
  });

  test('should remove watchlists movie from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlist(testMovieDetail))
        .thenAnswer((_) async => Right('Removed from watchlists'));
    // act
    final result = await usecase.execute(testMovieDetail);
    // assert
    verify(mockMovieRepository.removeWatchlist(testMovieDetail));
    expect(result, Right('Removed from watchlists'));
  });
}
