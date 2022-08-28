import 'package:equatable/equatable.dart';
import 'package:movies/movies.dart';
import 'package:tv_shows/tv_shows.dart';

///
/// Type :
/// 1 -> Movie
/// 2 -> Tv Show
class WatchlistTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final int? type;

  WatchlistTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.type,
  });

  factory WatchlistTable.fromMovieEntity(MovieDetail movie) => WatchlistTable(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      type: 1);

  factory WatchlistTable.fromMap(Map<String, dynamic> map) => WatchlistTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        type: map['type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'type': type
      };

  Movie toMovieEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
      );

  @override
  List<Object?> get props => [id, title, posterPath, overview];

  factory WatchlistTable.fromTvShowEntity(TvShowDetail movie) => WatchlistTable(
      id: movie.id,
      title: movie.name,
      posterPath: movie.posterPath,
      overview: movie.overview,
      type: 2);

  TvShow toTvShowEntity() => TvShow.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        name: title,
      );
}
