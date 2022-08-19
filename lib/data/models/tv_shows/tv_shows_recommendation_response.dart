import 'package:ditonton/data/models/tv_shows/tv_shows_model.dart';

class TvShowRecommendationsResponse{
  TvShowRecommendationsResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<TvShowModel> results;
  final int totalPages;
  final int totalResults;

  factory TvShowRecommendationsResponse.fromJson(Map<String, dynamic> json) => TvShowRecommendationsResponse(
    page: json["page"],
    results: List<TvShowModel>.from(json["results"].map((x) => TvShowModel.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );
}
