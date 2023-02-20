import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_from_api/api.dart';
import 'package:movie_from_api/movie.dart';
import 'package:movie_from_api/movie_state.dart';
import 'package:movie_from_api/service/movie_service.dart';

final movieProvider = StateNotifierProvider<MovieProvider, MovieState>(
    (ref) => MovieProvider(MovieState.initState()));

class MovieProvider extends StateNotifier<MovieState> {
  MovieProvider(super.state) {
    getMovieData();
  }

  Future<void> getMovieData() async {
    try {
      if (state.searchText.isEmpty) {
        state = state.copyWith(isLoad: state.loadMore ? false : true);
        final response =
            await MovieService.getMovieByCategory(state.apiPath, state.page);
        state = state.copyWith(
            isLoad: false,
            movies: [...state.movies, ...response],
            errMessage: '');
      } else {
        state = state.copyWith(isLoad: state.loadMore ? false : true);
        final searchResponse = await MovieService.searchMovieBy(
            query: state.searchText, page: state.page, apiPath: state.apiPath);
        state = state.copyWith(
            isLoad: false,
            movies: [...state.movies, ...searchResponse],
            errMessage: '');
      }
    } catch (err) {
      print(err);
      state = state.copyWith(
          isLoad: false,
          // movieState: state,
          errMessage: err as String);
    }
  }

  void updateApi(final String movieApi) {
    state = state.copyWith(
        movies: [],
        apiPath: movieApi,
        loadMore: false,
        page: 1,
        searchText: '');
    getMovieData();
  }

  void searchMovie(final String searchTxt) {
    state = state.copyWith(
        movies: [], searchText: searchTxt, apiPath: Api.searchMovieApi);

    getMovieData();
  }

  void loadMore() {
    state = state.copyWith(
        // movieState: state,
        isLoad: false,
        page: state.page + 1,
        searchText: state.searchText.isEmpty ? '' : state.searchText,
        loadMore: true);

    getMovieData();
  }
}

// final searchProvider = ChangeNotifierProvider.autoDispose((ref) => SearchMovieProvider());

// class SearchMovieProvider extends ChangeNotifier {
//   List<Movie> searchMovies = [];

//   Future<void> getMovieData({required String query}) async {
//     try {
//       final response = await MovieService.searchMovie(query: query);
//       searchMovies = response;
//       notifyListeners();
//     } catch (err) {
//       print(err);
//     }
//   }
// }

final keyProvider =
    FutureProvider.family((ref, int id) => MovieKeyProvider().getMovieKey(id));

class MovieKeyProvider {
  Future<String> getMovieKey(int id) async {
    final dio = Dio();
    try {
      final response = await dio.get(
          'https://api.themoviedb.org/3/movie/$id/videos',
          queryParameters: {
            'api_key': '2a0f926961d00c667e191a21c14461f8',
          });
      return response.data['results'][0]['key'];
    } on DioError catch (err) {
      print(err);
      return '';
    }
  }
}
