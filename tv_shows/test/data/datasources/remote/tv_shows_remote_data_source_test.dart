import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:tv_shows/data/datasources/remote/tv_show_remote_data_source.dart';
import 'package:tv_shows/data/models/tv_show_detail_model.dart';
import 'package:tv_shows/data/models/tv_shows_recommendation_response.dart';
import 'package:tv_shows/data/models/tv_shows_response.dart';

import '../../../helpers/json_reader.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  const apiKey = 'api_key=613d0b39cd7106ce0d332bbc4000cb24';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvShowRemoteDataSourceImpl dataSource;
  late MockApiIOClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockApiIOClient();
    dataSource = TvShowRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On Air Tv Shows', () {
    final tTvShowList = TvShowsResponse.fromJson(
            json.decode(readJson('data/dummy_data/on_air.json')))
        .tvShowModel;

    test('should return list of TvShowModel when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('data/dummy_data/on_air.json'), 200));
      // act
      final result = await dataSource.getOnAirTvShows();
      // assert
      expect(result, equals(tTvShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getOnAirTvShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tv Shows', () {
    final tTvShowList = TvShowsResponse.fromJson(
            json.decode(readJson('data/dummy_data/popular.json')))
        .tvShowModel;

    test('should return list of TvShowModel when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('data/dummy_data/popular.json'), 200));
      // act
      final result = await dataSource.getPopularTvShows();
      // assert
      expect(result, equals(tTvShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTvShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Tv Shows', () {
    final tTvShowList = TvShowsResponse.fromJson(
            json.decode(readJson('data/dummy_data/top_rated.json')))
        .tvShowModel;

    test('should return list of TvShowModel when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('data/dummy_data/top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedTvShows();
      // assert
      expect(result, equals(tTvShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTvShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Tv Show detail', () {
    final tId = 92749;
    final tvShowDetail = TvShowDetailResponse.fromJson(
        json.decode(readJson('data/dummy_data/tv_show_details.json')));

    test('should return tv show detail when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('data/dummy_data/tv_show_details.json'), 200));
      // act
      final result = await dataSource.getTvShowDetail(tId);
      // assert
      expect(result, equals(tvShowDetail));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvShowDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv show recommendations', () {
    final tTvShowList = TvShowRecommendationsResponse.fromJson(json.decode(
            readJson('data/dummy_data/tv_shows_recommendation.json')))
        .results;
    final tId = 92749;

    test('should return list of Tv Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('data/dummy_data/tv_shows_recommendation.json'),
              200));
      // act
      final result = await dataSource.getTvShowRecommendations(tId);
      // assert
      expect(result, equals(tTvShowList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvShowRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search Tv Shows', () {
    final tSearchResult = TvShowsResponse.fromJson(
        json.decode(readJson('data/dummy_data/search_moon_knight_tv_show.json')))
        .tvShowModel;
    final tQuery = 'moon knight';

    test('should return list of tvShow when response code is 200', () async {
      // arrange
      when(mockHttpClient
          .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('data/dummy_data/search_moon_knight_tv_show.json'), 200));
      // act
      final result = await dataSource.searchTvShows(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.searchTvShows(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });
}
