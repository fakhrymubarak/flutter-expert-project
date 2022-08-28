import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/presentation/bloc/home/top_rated/top_rated_bloc.dart';
import 'package:tv_shows/presentation/pages/top_rated_tv_show_page.dart';

class MockTvShowTopRatedBloc
    extends MockBloc<TvShowTopRatedEvent, TvShowTopRatedState>
    implements TvShowTopRatedBloc {}

class FakeTvShowTopRatedEvent extends Fake implements TvShowTopRatedEvent {}

class FakeTvShowTopRatedState extends Fake implements TvShowTopRatedState {}

void main() {
  late MockTvShowTopRatedBloc mockTvShowTopRatedBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvShowTopRatedEvent());
    registerFallbackValue(FakeTvShowTopRatedState());
  });

  setUp(() {
    mockTvShowTopRatedBloc = MockTvShowTopRatedBloc();
  });

  tearDown(() {
    mockTvShowTopRatedBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvShowTopRatedBloc>(
      create: (_) => mockTvShowTopRatedBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockTvShowTopRatedBloc.add(TopRatedFetched()))
            .thenAnswer((invocation) {});
        when(() => mockTvShowTopRatedBloc.state)
            .thenAnswer((invocation) => TopRatedLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowsPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockTvShowTopRatedBloc.add(TopRatedFetched()))
            .thenAnswer((invocation) {});
        when(() => mockTvShowTopRatedBloc.state)
            .thenAnswer((invocation) => TopRatedHasData(<TvShow>[]));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowsPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockTvShowTopRatedBloc.add(TopRatedFetched()))
            .thenAnswer((invocation) {});
        when(() => mockTvShowTopRatedBloc.state)
            .thenAnswer((invocation) => TopRatedError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvShowsPage()));

        expect(textFinder, findsOneWidget);
      });
}
