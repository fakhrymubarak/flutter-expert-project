import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/domain/usecases/get_top_rated_tv_shows.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvShows usecase;
  late MockTvShowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvShowRepository();
    usecase = GetTopRatedTvShows(mockRepository);
  });

  final tTvShows = <TvShow>[];

  test('should get list of tv shows from the repository', () async {
    // arrange
    when(mockRepository.getTopRatedTvShows())
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShows));
  });
}
