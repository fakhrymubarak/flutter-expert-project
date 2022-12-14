import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies/presentation/bloc/details/movie_detail_bloc.dart';
import 'package:movies/presentation/bloc/watchlist/movie_watchlist_bloc.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';

import '../../data/dummy_data/dummy_objects_movie.dart';

// Mock bloc
class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockMovieWatchlistBloc
    extends MockBloc<MovieWatchlistEvent, MovieWatchlistState>
    implements MovieWatchlistBloc {}

//  Mock event
class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieWatchlistEvent extends Fake implements MovieWatchlistEvent {}

// Mock State
class FakeMovieDetailState extends Fake implements MovieDetailState {}

class FakeMovieWatchlistState extends Fake implements MovieWatchlistState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieWatchlistBloc mockMovieWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());

    registerFallbackValue(FakeMovieWatchlistEvent());
    registerFallbackValue(FakeMovieWatchlistState());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieWatchlistBloc = MockMovieWatchlistBloc();
  });

  tearDown(() {
    mockMovieDetailBloc.close();
    mockMovieWatchlistBloc.close();
  });

  final tId = 557;

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(create: (_) => mockMovieDetailBloc),
        BlocProvider<MovieWatchlistBloc>(create: (_) => mockMovieWatchlistBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  void _arrangeDetailHasDataBloc() {
    when(() => mockMovieDetailBloc.add(MovieDetailFetched(tId)))
        .thenAnswer((invocation) {});
    when(() => mockMovieDetailBloc.state).thenAnswer(
      (invocation) => MovieDetailHasData(testMovieDetail, [testMovie]),
    );
  }

  group("Display Details Data", () {
    _arrangeDetailBloc() {
      when(() => mockMovieDetailBloc.add(MovieDetailFetched(tId)))
          .thenAnswer((invocation) {});
    }

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      _arrangeDetailBloc();
      when(() => mockMovieDetailBloc.state)
          .thenAnswer((invocation) => MovieDetailLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      _arrangeDetailBloc();
      when(() => mockMovieDetailBloc.state).thenAnswer(
          (invocation) => MovieDetailError('Error Message', 'Error Message'));

      final textFinder = find.byKey(Key('error_message_detail'));
      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

      expect(textFinder, findsOneWidget);
    });
  });

  group("Watchlist Button Interaction", () {
    testWidgets(
        'Watchlist button should display add icon when movie not added to watchlists',
        (WidgetTester tester) async {
      _arrangeDetailHasDataBloc();
      when(() => mockMovieWatchlistBloc.state).thenAnswer((invocation) =>
          MovieWatchlistStatusData(
              false, MovieWatchlistBloc.watchlistRemoveSuccessMessage));
      final watchlistButtonIcon = find.byIcon(Icons.add);
      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));
      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display check icon when movie is added to wathclist',
        (WidgetTester tester) async {
      _arrangeDetailHasDataBloc();
      when(() => mockMovieWatchlistBloc.state).thenAnswer((invocation) =>
          MovieWatchlistStatusData(
              true, MovieWatchlistBloc.watchlistAddSuccessMessage));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

      expect(watchlistButtonIcon, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display Snackbar when added to watchlists',
        (WidgetTester tester) async {
      _arrangeDetailHasDataBloc();
      when(() => mockMovieWatchlistBloc.add(
          MovieSavedToWatchlist(testMovieDetail))).thenAnswer((invocation) {});
      when(() => mockMovieWatchlistBloc.state).thenAnswer(
        (invocation) => MovieWatchlistStatusData(false, ''),
      );

      final watchlistButton = find.byType(ElevatedButton);
      final expectedStates = [
        MovieWatchlistStatusData(false, ''),
        MovieWatchlistStatusData(true, 'Added to Watchlist')
      ];

      whenListen(mockMovieWatchlistBloc, Stream.fromIterable(expectedStates));
      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    });

    testWidgets(
        'Watchlist button should display AlertDialog when add to watchlists failed',
        (WidgetTester tester) async {
      _arrangeDetailHasDataBloc();
      when(() => mockMovieWatchlistBloc.add(
          MovieSavedToWatchlist(testMovieDetail))).thenAnswer((invocation) {});
      when(() => mockMovieWatchlistBloc.state).thenAnswer(
        (invocation) => MovieWatchlistStatusData(false, ''),
      );

      final watchlistButton = find.byType(ElevatedButton);
      final expectedStates = [
        MovieWatchlistStatusData(false, ''),
        MovieWatchlistStatusData(false, 'Failed')
      ];

      whenListen(mockMovieWatchlistBloc, Stream.fromIterable(expectedStates));
      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Failed'), findsNothing);

      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(AlertDialog), findsWidgets);
      expect(find.text('Failed'), findsOneWidget);
    });
  });
}
