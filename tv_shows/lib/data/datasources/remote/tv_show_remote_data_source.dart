import 'dart:convert';

import 'package:core/core.dart';
import 'package:tv_shows/data/models/tv_show_detail_model.dart';
import 'package:tv_shows/data/models/tv_shows_model.dart';
import 'package:tv_shows/data/models/tv_shows_recommendation_response.dart';
import 'package:tv_shows/data/models/tv_shows_response.dart';

abstract class TvShowRemoteDataSource {
  Future<List<TvShowModel>> getOnAirTvShows();
  Future<List<TvShowModel>> getPopularTvShows();
  Future<List<TvShowModel>> getTopRatedTvShows();
  Future<TvShowDetailResponse> getTvShowDetail(int id);
  Future<List<TvShowModel>> getTvShowRecommendations(int id);
  Future<List<TvShowModel>> searchTvShows(String query);
}

class TvShowRemoteDataSourceImpl implements TvShowRemoteDataSource {
  static const apiKey = 'api_key=613d0b39cd7106ce0d332bbc4000cb24';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final ApiIOClient client;

  TvShowRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvShowModel>> getOnAirTvShows() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey'));

    if (response.statusCode == 200) {
      return TvShowsResponse.fromJson(json.decode(response.body)).tvShowModel;
    } else {
      throw ServerException();
    }
  }
  @override
  Future<List<TvShowModel>> getPopularTvShows() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/popular?$apiKey'));

    if (response.statusCode == 200) {
      return TvShowsResponse.fromJson(json.decode(response.body)).tvShowModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTopRatedTvShows() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey'));

    if (response.statusCode == 200) {
      return TvShowsResponse.fromJson(json.decode(response.body)).tvShowModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvShowDetailResponse> getTvShowDetail(int id) async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TvShowDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTvShowRecommendations(int id) async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'));

    if (response.statusCode == 200) {
      return TvShowRecommendationsResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> searchTvShows(String query) async {
    final response = await client.get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'));

    if (response.statusCode == 200) {
      return TvShowsResponse.fromJson(json.decode(response.body)).tvShowModel;
    } else {
      throw ServerException();
    }
  }
}
