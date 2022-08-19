import 'package:ditonton/data/models/tv_shows/tv_shows_model.dart';

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

}
