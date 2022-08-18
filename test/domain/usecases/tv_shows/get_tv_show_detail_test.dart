import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_shows/get_tv_show_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_shows/dummy_objects_tv_show.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvShowDetail usecase;
  late MockTvShowRepository mockRepository;

  setUp(() {
    mockRepository = MockTvShowRepository();
    usecase = GetTvShowDetail(mockRepository);
  });

  test('should get tv show detail from the repository', () async {
    final tId = 1;
    // arrange
    when(mockRepository.getTvShowDetail(tId))
        .thenAnswer((_) async => Right(testTvShowDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(testTvShowDetail));
  });
}
