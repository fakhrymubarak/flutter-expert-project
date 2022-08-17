import 'dart:convert';

import 'package:ditonton/data/models/tv_shows/tv_shows_model.dart';

TvShowsResponse tvShowsResponseFromJson(String str) => TvShowsResponse.fromJson(json.decode(str));

String tvShowsResponseToJson(TvShowsResponse data) => json.encode(data.toJson());

class TvShowsResponse {
  TvShowsResponse({
    required this.page,
    required this.tvShowModel,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<TvShowModel> tvShowModel;
  int totalPages;
  int totalResults;

  factory TvShowsResponse.fromJson(Map<String, dynamic> json) => TvShowsResponse(
    page: json["page"],
    tvShowModel: List<TvShowModel>.from(json["results"].map((x) => TvShowModel.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(tvShowModel.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}
