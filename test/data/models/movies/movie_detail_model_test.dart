import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movies/movie_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: "backdropPath",
    budget: 0,
    genres: [GenreModel(id: 1, name: "name")],
    homepage: "homepage",
    id: 1,
    imdbId: 'imdbId',
    originalLanguage: "originalLanguage",
    originalTitle: "originalTitle",
    overview: "overview",
    popularity: 0,
    posterPath: "posterPath",
    releaseDate: "releaseDate",
    revenue: 0,
    runtime: 0,
    status: "status",
    tagline: "tagline",
    title: "title",
    video: true,
    voteAverage: 0,
    voteCount: 0,
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: "backdropPath",
    genres: [Genre(id: 1, name: "name")],
    id: 1,
    originalTitle: "originalTitle",
    overview: "overview",
    posterPath: "posterPath",
    releaseDate: "releaseDate",
    runtime: 0,
    title: "title",
    voteAverage: 0,
    voteCount: 0,
  );

  test('should be a subclass of Movie entity', () async {
    final result = tMovieDetailResponse.toEntity();
    expect(result, tMovieDetail);
  });

}
