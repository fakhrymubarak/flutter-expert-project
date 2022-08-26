import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_shows/details/tv_show_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_shows/tv_show_watchlist/tv_show_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/tv_shows/tv_show_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/tv_shows/dummy_objects_tv_show.dart';

// Mock bloc
class MockTvShowDetailBloc extends MockBloc<TvShowDetailEvent, TvShowDetailState>
    implements TvShowDetailBloc {}

class MockTvShowWatchlistBloc
    extends MockBloc<TvShowWatchlistEvent, TvShowWatchlistState>
    implements TvShowWatchlistBloc {}

//  Mock event
class FakeTvShowDetailEvent extends Fake implements TvShowDetailEvent {}

class FakeTvShowWatchlistEvent extends Fake implements TvShowWatchlistEvent {}

// Mock State
class FakeTvShowDetailState extends Fake implements TvShowDetailState {}

class FakeTvShowWatchlistState extends Fake implements TvShowWatchlistState {}

void main() {
  late MockTvShowDetailBloc mockTvShowDetailBloc;
  late MockTvShowWatchlistBloc mockTvShowWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvShowDetailEvent());
    registerFallbackValue(FakeTvShowDetailState());

    registerFallbackValue(FakeTvShowWatchlistEvent());
    registerFallbackValue(FakeTvShowWatchlistState());
  });

  setUp(() {
    mockTvShowDetailBloc = MockTvShowDetailBloc();
    mockTvShowWatchlistBloc = MockTvShowWatchlistBloc();
  });

  tearDown(() {
    mockTvShowDetailBloc.close();
    mockTvShowWatchlistBloc.close();
  });

  final tId = 557;

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvShowDetailBloc>(create: (_) => mockTvShowDetailBloc),
        BlocProvider<TvShowWatchlistBloc>(create: (_) => mockTvShowWatchlistBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  void _arrangeBloc() {
    when(() => mockTvShowDetailBloc.add(TvShowDetailFetched(tId)))
        .thenAnswer((invocation) {});
    when(() => mockTvShowDetailBloc.state).thenAnswer(
          (invocation) => TvShowDetailHasData(testTvShowDetail, [testTvShow]),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv show not added to watchlists',
          (WidgetTester tester) async {
        _arrangeBloc();
        when(() => mockTvShowWatchlistBloc.state).thenAnswer((invocation) =>
            TvShowWatchlistStatusData(
                false, TvShowWatchlistBloc.watchlistRemoveSuccessMessage));
        final watchlistButtonIcon = find.byIcon(Icons.add);
        await tester.pumpWidget(_makeTestableWidget(TvShowDetailPage(id: tId)));
        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display check icon when tv show is added to wathclist',
          (WidgetTester tester) async {
        _arrangeBloc();
        when(() => mockTvShowWatchlistBloc.state).thenAnswer((invocation) =>
            TvShowWatchlistStatusData(
                true, TvShowWatchlistBloc.watchlistAddSuccessMessage));

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(TvShowDetailPage(id: tId)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlists',
          (WidgetTester tester) async {
        _arrangeBloc();
        when(() =>
            mockTvShowWatchlistBloc.add(TvShowSavedToWatchlist(testTvShowDetail)))
            .thenAnswer((invocation) {});
        when(() => mockTvShowWatchlistBloc.state).thenAnswer(
              (invocation) => TvShowWatchlistStatusData(false, ''),
        );

        final watchlistButton = find.byType(ElevatedButton);
        final expectedStates = [
          TvShowWatchlistStatusData(false, ''),
          TvShowWatchlistStatusData(true, 'Added to Watchlist')
        ];

        whenListen(mockTvShowWatchlistBloc, Stream.fromIterable(expectedStates));
        await tester.pumpWidget(_makeTestableWidget(TvShowDetailPage(id: tId)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton, warnIfMissed: false);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlists failed',
          (WidgetTester tester) async {
        _arrangeBloc();
        when(() =>
            mockTvShowWatchlistBloc.add(TvShowSavedToWatchlist(testTvShowDetail)))
            .thenAnswer((invocation) {});
        when(() => mockTvShowWatchlistBloc.state).thenAnswer(
              (invocation) => TvShowWatchlistStatusData(false, ''),
        );

        final watchlistButton = find.byType(ElevatedButton);
        final expectedStates = [
          TvShowWatchlistStatusData(false, ''),
          TvShowWatchlistStatusData(false, 'Failed')
        ];

        whenListen(mockTvShowWatchlistBloc, Stream.fromIterable(expectedStates));
        await tester.pumpWidget(_makeTestableWidget(TvShowDetailPage(id: tId)));

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('Failed'), findsNothing);

        await tester.tap(watchlistButton, warnIfMissed: false);
        await tester.pump();

        expect(find.byType(AlertDialog), findsWidgets);
        expect(find.text('Failed'), findsOneWidget);
      });
}
