import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_from_api/api.dart';
import 'package:movie_from_api/movie.dart';

import 'dio_error_handling.dart';

class MovieService {
  static Future<List<Movie>> getMovieByCategory(
      final apiPath, final int page) async {
    final dio = Dio();
    try {
      if (apiPath == Api.popularMovieApi) {
        final response = await dio.get(apiPath, queryParameters: {
          'api_key': 'e1235dbabc639f4dbf9b1875b78c6fe8',
          'page': 1
        });
        final box = Hive.box<String>('data');
        box.put('movie', jsonEncode(response.data['results']));
        final movieData = (response.data['results'] as List)
            .map((e) => Movie.fromJson(e))
            .toList();

        return movieData;
      } else {
        final response = await dio.get(apiPath, queryParameters: {
          'api_key': 'e1235dbabc639f4dbf9b1875b78c6fe8',
          'page': page
        });
        //local data save from hive

        final movieData = (response.data['results'] as List)
            .map((e) => Movie.fromJson(e))
            .toList();

        return movieData;
      }
    } on DioError catch (err) {
      // print(err.message);
      // print(err.type);
      if (apiPath == Api.popularMovieApi) {
        final box = Hive.box<String>('data');
        final boxData = box.get('movie');
        final dat = (jsonDecode(boxData!) as List)
            .map((e) => Movie.fromJson(e))
            .toList();
        return dat;
      } else {
        throw ErrorHandling().errorMessage(err);
      }
    }
  }

  static Future<List<Movie>> searchMovieBy(
      {required String query,
      required String apiPath,
      required int page}) async {
    final dio = Dio();

    try {
      final response = await dio.get(Api.searchMovieApi, queryParameters: {
        'api_key': '2a0f926961d00c667e191a21c14461f8',
        'query': query,
        'page': page
      });
      if ((response.data['results'] as List).isEmpty) {
        throw 'Search Not Found !!';
      } else {
        final data = (response.data['results'] as List)
            .map((e) => Movie.fromJson(e))
            .toList();
        return data;
      }
    } on DioError catch (err) {
      throw ErrorHandling().errorMessage(err);
    }
  }
}
