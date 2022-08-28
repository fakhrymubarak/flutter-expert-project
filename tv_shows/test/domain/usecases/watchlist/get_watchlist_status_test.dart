import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_shows/domain/usecases/watchlist/get_watchlist_status.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvShowWatchListStatus usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTvShowWatchListStatus(mockTvShowRepository);
  });


  test('should get tv show watchlists status from repository', () async {
    // arrange
    when(mockTvShowRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
