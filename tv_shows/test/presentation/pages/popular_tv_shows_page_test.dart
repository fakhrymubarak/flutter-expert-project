import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_shows/domain/entities/tv_show.dart';
import 'package:tv_shows/presentation/bloc/home/popular/popular_bloc.dart';
import 'package:tv_shows/presentation/pages/popular_tv_show_page.dart';

class MockTvShowPopularBloc extends MockBloc<TvShowPopularEvent, TvShowPopularState>
    implements TvShowPopularBloc {}

class FakeTvShowPopularEvent extends Fake implements TvShowPopularEvent {}

class FakeTvShowPopularState extends Fake implements TvShowPopularState {}

void main() {
  late MockTvShowPopularBloc mockTvShowPopularBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvShowPopularEvent());
    registerFallbackValue(FakeTvShowPopularState());
  });

  setUp(() {
    mockTvShowPopularBloc = MockTvShowPopularBloc();
  });

  tearDown(() {
    mockTvShowPopularBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvShowPopularBloc>(
      create: (_) => mockTvShowPopularBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockTvShowPopularBloc.add(PopularFetched()))
            .thenAnswer((invocation) {});
        when(() => mockTvShowPopularBloc.state)
            .thenAnswer((invocation) => PopularLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularTvShowsPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockTvShowPopularBloc.add(PopularFetched()))
            .thenAnswer((invocation) {});
        when(() => mockTvShowPopularBloc.state)
            .thenAnswer((invocation) => PopularHasData(<TvShow>[]));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(PopularTvShowsPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockTvShowPopularBloc.add(PopularFetched()))
            .thenAnswer((invocation) {});
        when(() => mockTvShowPopularBloc.state)
            .thenAnswer((invocation) => PopularError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(PopularTvShowsPage()));

        expect(textFinder, findsOneWidget);
      });
}