import 'package:ditonton/domain/usecases/watchlists/get_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetMovieWatchListStatus usecase;
  late MockMovieRepository mockMovieRepository;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetMovieWatchListStatus(mockMovieRepository, mockTvShowRepository);
  });

  test('should get movie watchlists status from repository', () async {
    // arrange
    when(mockMovieRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1, true);
    // assert
    expect(result, true);
  });


  test('should get tv show watchlists status from repository', () async {
    // arrange
    when(mockTvShowRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1, false);
    // assert
    expect(result, true);
  });
}
