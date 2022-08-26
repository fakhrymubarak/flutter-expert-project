import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/lib/utils/failure.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/usecases/tv_shows/search_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv_shows/search/search_tv_shows_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_tv_shows_test.mocks.dart';

@GenerateMocks([SearchTvShows])
void main() {
  late SearchTvShowsBloc searchTvShowsBloc;
  late MockSearchTvShows mockSearchTvShows;

  setUp(() {
    mockSearchTvShows = MockSearchTvShows();
    searchTvShowsBloc = SearchTvShowsBloc(mockSearchTvShows);
  });

  final tTvShowModel = TvShow(
      backdropPath: "/vfWdZYGR5505zrCdgTHteFyARu3.jpg",
      firstAirDate: "2022-03-30",
      genreIds: [10759, 10765, 9648],
      id: 92749,
      name: "Moon Knight",
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Moon Knight",
      overview:
          "When Steven Grant, a mild-mannered gift-shop employee, becomes plagued with blackouts and memories of another life, he discovers he has dissociative identity disorder and shares a body with mercenary Marc Spector. As Steven/Marc's enemies converge upon them, they must navigate their complex identities while thrust into a deadly mystery among the powerful gods of Egypt.",
      popularity: 543.452,
      posterPath: "/YksR65as1ppF2N48TJAh2PLamX.jpg",
      voteAverage: 8.1,
      voteCount: 1375);
  final tTvShowList = <TvShow>[tTvShowModel];
  final tQuery = 'spiderman';

  blocTest<SearchTvShowsBloc, SearchTvShowsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTvShowList));
      return searchTvShowsBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvShowsLoading(),
      SearchTvShowsHasData(tTvShowList),
    ],
    verify: (bloc) {
      verify(mockSearchTvShows.execute(tQuery));
    },
  );

  blocTest<SearchTvShowsBloc, SearchTvShowsState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchTvShowsBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvShowsLoading(),
      SearchTvShowsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvShows.execute(tQuery));
    },
  );
}
