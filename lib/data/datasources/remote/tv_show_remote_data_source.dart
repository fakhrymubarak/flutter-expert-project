import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/ssl_pinning.dart';
import 'package:ditonton/data/models/tv_shows/tv_show_detail_model.dart';
import 'package:ditonton/data/models/tv_shows/tv_shows_model.dart';
import 'package:ditonton/data/models/tv_shows/tv_shows_recommendation_response.dart';
import 'package:ditonton/data/models/tv_shows/tv_shows_response.dart';

abstract class TvShowRemoteDataSource {
  Future<List<TvShowModel>> getOnAirTvShows();
  Future<List<TvShowModel>> getPopularTvShows();
  Future<List<TvShowModel>> getTopRatedTvShows();
  Future<TvShowDetailResponse> getTvShowDetail(int id);
  Future<List<TvShowModel>> getTvShowRecommendations(int id);
  Future<List<TvShowModel>> searchTvShows(String query);
}

class TvShowRemoteDataSourceImpl implements TvShowRemoteDataSource {
  static const API_KEY = 'api_key=613d0b39cd7106ce0d332bbc4000cb24';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final ApiIOClient client;

  TvShowRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvShowModel>> getOnAirTvShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowsResponse.fromJson(json.decode(response.body)).tvShowModel;
    } else {
      throw ServerException();
    }
  }
  @override
  Future<List<TvShowModel>> getPopularTvShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowsResponse.fromJson(json.decode(response.body)).tvShowModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTopRatedTvShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowsResponse.fromJson(json.decode(response.body)).tvShowModel;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvShowDetailResponse> getTvShowDetail(int id) async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTvShowRecommendations(int id) async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowRecommendationsResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> searchTvShows(String query) async {
    final response = await client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TvShowsResponse.fromJson(json.decode(response.body)).tvShowModel;
    } else {
      throw ServerException();
    }
  }
}
