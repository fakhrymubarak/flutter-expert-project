import 'package:equatable/equatable.dart';
import 'package:tv_shows/domain/entities/tv_show_detail.dart';

class EpisodeModel extends Equatable {
  EpisodeModel({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final DateTime? airDate;
  final int? episodeNumber;
  final int id;
  final String? name;
  final String? overview;
  final String? productionCode;
  final int? runtime;
  final int? seasonNumber;
  final int? showId;
  final String? stillPath;
  final double? voteAverage;
  final int? voteCount;

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        airDate: DateTime.parse(json["air_date"]),
        episodeNumber: json["episode_number"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        productionCode: json["production_code"],
        runtime: json["runtime"],
        seasonNumber: json["season_number"],
        showId: json["show_id"],
        stillPath: json["still_path"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
      );

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        productionCode,
        runtime,
        seasonNumber,
        showId,
        stillPath,
        voteAverage,
        voteCount,
      ];

  Episode toEntity() => Episode(
        airDate: airDate ?? DateTime(2000, 01, 01),
        episodeNumber: episodeNumber ?? 0,
        id: id,
        name: name ?? "",
        overview: overview ?? "",
        productionCode: productionCode ?? "",
        runtime: runtime ?? 0,
        seasonNumber: seasonNumber ?? 0,
        showId: showId ?? 0,
        stillPath: stillPath ?? "",
        voteAverage: voteAverage ?? 0,
        voteCount: voteCount ?? 0,
      );
}
