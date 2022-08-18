import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_shows/author_model.dart';
import 'package:ditonton/data/models/tv_shows/episode_model.dart';
import 'package:ditonton/data/models/tv_shows/network_model.dart';
import 'package:ditonton/data/models/tv_shows/season_model.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:equatable/equatable.dart';

class TvShowDetailResponse extends Equatable{
  TvShowDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.nextEpisodeToAir,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.seasons,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String backdropPath;
  final List<AuthorModel> createdBy;
  final List<int> episodeRunTime;
  final DateTime firstAirDate;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final DateTime lastAirDate;
  final EpisodeModel lastEpisodeToAir;
  final String name;
  final EpisodeModel nextEpisodeToAir;
  final List<NetworkModel> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<NetworkModel> productionCompanies;
  final List<SeasonModel> seasons;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  factory TvShowDetailResponse.fromJson(Map<String, dynamic> json) => TvShowDetailResponse(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    createdBy: List<AuthorModel>.from(json["created_by"].map((x) => AuthorModel.fromJson(x))),
    episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
    firstAirDate: DateTime.parse(json["first_air_date"]),
    genres: List<GenreModel>.from(json["genres"].map((x) => GenreModel.fromJson(x))),
    homepage: json["homepage"],
    id: json["id"],
    inProduction: json["in_production"],
    languages: List<String>.from(json["languages"].map((x) => x)),
    lastAirDate: DateTime.parse(json["last_air_date"]),
    lastEpisodeToAir: EpisodeModel.fromJson(json["last_episode_to_air"]),
    name: json["name"],
    nextEpisodeToAir: EpisodeModel.fromJson(json["next_episode_to_air"]),
    networks: List<NetworkModel>.from(json["networks"].map((x) => NetworkModel.fromJson(x))),
    numberOfEpisodes: json["number_of_episodes"],
    numberOfSeasons: json["number_of_seasons"],
    originCountry: List<String>.from(json["origin_country"].map((x) => x)),
    originalLanguage: json["original_language"],
    originalName: json["original_name"],
    overview: json["overview"],
    popularity: json["popularity"].toDouble(),
    posterPath: json["poster_path"],
    productionCompanies: List<NetworkModel>.from(json["production_companies"].map((x) => NetworkModel.fromJson(x))),
    seasons: List<SeasonModel>.from(json["seasons"].map((x) => SeasonModel.fromJson(x))),
    status: json["status"],
    tagline: json["tagline"],
    type: json["type"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "created_by": List<dynamic>.from(createdBy.map((x) => x.toJson())),
    "episode_run_time": List<dynamic>.from(episodeRunTime.map((x) => x)),
    "first_air_date": "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "in_production": inProduction,
    "languages": List<dynamic>.from(languages.map((x) => x)),
    "last_air_date": "${lastAirDate.year.toString().padLeft(4, '0')}-${lastAirDate.month.toString().padLeft(2, '0')}-${lastAirDate.day.toString().padLeft(2, '0')}",
    "last_episode_to_air": lastEpisodeToAir.toJson(),
    "name": name,
    "next_episode_to_air": nextEpisodeToAir.toJson(),
    "networks": List<dynamic>.from(networks.map((x) => x.toJson())),
    "number_of_episodes": numberOfEpisodes,
    "number_of_seasons": numberOfSeasons,
    "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
    "original_language": originalLanguage,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "production_companies": List<dynamic>.from(productionCompanies.map((x) => x.toJson())),
    "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
    "status": status,
    "tagline": tagline,
    "type": type,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    createdBy,
    episodeRunTime,
    firstAirDate,
    genres,
    homepage,
    id,
    inProduction,
    languages,
    lastAirDate,
    lastEpisodeToAir,
    name,
    nextEpisodeToAir,
    networks,
    numberOfEpisodes,
    numberOfSeasons,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    productionCompanies,
    seasons,
    status,
    tagline,
    type,
    voteAverage,
    voteCount
  ];

  TvShowDetail toEntity() =>
      TvShowDetail(
          adult: this.adult,
          backdropPath: this.backdropPath,
          createdBy:  this.createdBy.map((e) => e.toEntity()).toList(),
          episodeRunTime: this.episodeRunTime,
          firstAirDate: this.firstAirDate,
          genres: this.genres.map((e) => e.toEntity()).toList(),
          homepage: this.homepage,
          id: this.id,
          inProduction: this.inProduction,
          languages: this.languages,
          lastAirDate: this.lastAirDate,
          lastEpisodeToAir: this.lastEpisodeToAir.toEntity(),
          name: this.name,
          nextEpisodeToAir: this.nextEpisodeToAir.toEntity(),
          networks: this.networks.map((e) => e.toEntity()).toList(),
          numberOfEpisodes: this.numberOfEpisodes,
          numberOfSeasons: this.numberOfSeasons,
          originCountry: this.originCountry,
          originalLanguage: this.originalLanguage,
          originalName: this.originalName,
          overview: this.overview,
          popularity: this.popularity,
          posterPath: this.posterPath,
          productionCompanies: this.productionCompanies.map((e) => e.toEntity()).toList(),
          seasons: this.seasons.map((e) => e.toEntity()).toList(),
          status: this.status,
          tagline: this.tagline,
          type: this.type,
          voteAverage: this.voteAverage,
          voteCount: this.voteCount,
      );
}