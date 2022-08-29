import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/home/top_rated/top_rated_bloc.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';

import '../../data/dummy_data/dummy_objects_movie.dart';

class MockMovieTopRatedBloc
    extends MockBloc<MovieTopRatedEvent, MovieTopRatedState>
    implements MovieTopRatedBloc {}

class FakeMovieTopRatedEvent extends Fake implements MovieTopRatedEvent {}

class FakeMovieTopRatedState extends Fake implements MovieTopRatedState {}

void main() {
  late MockMovieTopRatedBloc mockMovieTopRatedBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieTopRatedEvent());
    registerFallbackValue(FakeMovieTopRatedState());
  });

  setUp(() {
    mockMovieTopRatedBloc = MockMovieTopRatedBloc();
  });

  tearDown(() {
    mockMovieTopRatedBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieTopRatedBloc>(
      create: (_) => mockMovieTopRatedBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockMovieTopRatedBloc.add(TopRatedFetched()))
        .thenAnswer((invocation) {});
    when(() => mockMovieTopRatedBloc.state)
        .thenAnswer((invocation) => TopRatedLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockMovieTopRatedBloc.add(TopRatedFetched()))
        .thenAnswer((invocation) {});
    when(() => mockMovieTopRatedBloc.state)
        .thenAnswer((invocation) => TopRatedHasData(<Movie>[testMovie]));

    final listViewFinder = find.byKey(Key('list_movies'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockMovieTopRatedBloc.add(TopRatedFetched()))
        .thenAnswer((invocation) {});
    when(() => mockMovieTopRatedBloc.state)
        .thenAnswer((invocation) => TopRatedError('Error Message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display nothing when state is empty ',
      (WidgetTester tester) async {
    when(() => mockMovieTopRatedBloc.add(TopRatedFetched()))
        .thenAnswer((invocation) {});
    when(() => mockMovieTopRatedBloc.state)
        .thenAnswer((invocation) => TopRatedEmpty());

    final emptyWidget = find.byKey(Key('empty_widget'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(emptyWidget, findsOneWidget);
  });
}
