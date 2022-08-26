import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movies/home/popular/popular_bloc.dart';
import 'package:ditonton/presentation/pages/movies/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMoviePopularBloc extends MockBloc<MoviePopularEvent, MoviePopularState>
    implements MoviePopularBloc {}

class FakeMoviePopularEvent extends Fake implements MoviePopularEvent {}

class FakeMoviePopularState extends Fake implements MoviePopularState {}

void main() {
  late MockMoviePopularBloc mockMoviePopularBloc;

  setUpAll(() {
    registerFallbackValue(FakeMoviePopularEvent());
    registerFallbackValue(FakeMoviePopularState());
  });

  setUp(() {
    mockMoviePopularBloc = MockMoviePopularBloc();
  });

  tearDown(() {
    mockMoviePopularBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MoviePopularBloc>(
      create: (_) => mockMoviePopularBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockMoviePopularBloc.add(PopularFetched()))
            .thenAnswer((invocation) {});
        when(() => mockMoviePopularBloc.state)
            .thenAnswer((invocation) => PopularLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockMoviePopularBloc.add(PopularFetched()))
            .thenAnswer((invocation) {});
        when(() => mockMoviePopularBloc.state)
            .thenAnswer((invocation) => PopularHasData(<Movie>[]));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockMoviePopularBloc.add(PopularFetched()))
            .thenAnswer((invocation) {});
        when(() => mockMoviePopularBloc.state)
            .thenAnswer((invocation) => PopularError('Error Message'));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

        expect(textFinder, findsOneWidget);
      });
}
