import 'package:movie_from_api/api.dart';
import 'package:movie_from_api/movie.dart';

class MovieState {
  final bool isLoad;
  final bool loadMore;
  final List<Movie> movies;
  final String errMessage;
  final String apiPath;
  final int page;
  final String searchText;

  MovieState(
      {required this.apiPath,
      required this.errMessage,
      required this.isLoad,
      required this.loadMore,
      required this.movies,
      required this.page,
      required this.searchText});

  factory MovieState.initState() {
    return MovieState(
        apiPath: Api.popularMovieApi,
        errMessage: '',
        isLoad: false,
        movies: [],
        page: 1,
        loadMore: false,
        searchText: '');
  }

  MovieState copyWith(
      {bool? isLoad,
      List<Movie>? movies,
      String? errMessage,
      String? apiPath,
      int? page,
      bool? loadMore,
      String? searchText}) {
    return MovieState(
      apiPath: apiPath ?? this.apiPath,
      errMessage: errMessage ?? this.errMessage,
      isLoad: isLoad ?? this.isLoad,
      movies: movies ?? this.movies,
      page: page ?? this.page,
      loadMore: loadMore ?? this.loadMore,
      searchText: searchText ?? this.searchText,
    );
  }
}
