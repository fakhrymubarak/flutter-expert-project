import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_shows/domain/usecases/watchlist/remove_tv_show_watchlist.dart';

import '../../../data/dummy_data/dummy_objects_tv_show.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvShowWatchlist usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = RemoveTvShowWatchlist(mockTvShowRepository);
  });

  test('should remove watchlists tv show from repository', () async {
    // arrange
    when(mockTvShowRepository.removeWatchlist(testTvShowDetail))
        .thenAnswer((_) async => Right('Removed from watchlists'));
    // act
    final result = await usecase.execute(testTvShowDetail);
    // assert
    verify(mockTvShowRepository.removeWatchlist(testTvShowDetail));
    expect(result, Right('Removed from watchlists'));
  });
}
