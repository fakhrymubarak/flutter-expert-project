import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_recommendation_tv_show.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvShowRecommendation usecase;
  late MockTvShowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvShowRepository();
    usecase = GetTvShowRecommendation(mockRepository);
  });

  final tId = 1;
  final tTvShows = <TvShow>[];

  test('should get list of tv shows recommendation from the repository', () async {
    // arrange
    when(mockRepository.getTvShowRecommendations(tId))
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvShows));
  });
}
