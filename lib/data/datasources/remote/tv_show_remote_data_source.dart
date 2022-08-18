import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_shows/tv_show_detail_model.dart';
import 'package:ditonton/data/models/tv_shows/tv_shows_model.dart';
import 'package:ditonton/data/models/tv_shows/tv_shows_recommendation_response.dart';
import 'package:ditonton/data/models/tv_shows/tv_shows_response.dart';
import 'package:http/http.dart' as http;

abstract class TvShowRemoteDataSource {
  Future<List<TvShowModel>> getOnAirTvShows();
  Future<List<TvShowModel>> getPopularTvShows();
  Future<List<TvShowModel>> getTopRatedTvShows();
  Future<TvShowDetailResponse> getTvShowDetails(int id);
  Future<List<TvShowModel>> getTvShowRecommendations(int id);
}

class TvShowRemoteDataSourceImpl implements TvShowRemoteDataSource {
  static const API_KEY = 'api_key=613d0b39cd7106ce0d332bbc4000cb24';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

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
  Future<TvShowDetailResponse> getTvShowDetails(int id) async {
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
}
