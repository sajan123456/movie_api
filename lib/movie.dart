import 'dart:convert';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String poster_path;
  final String vote_average;

  final String release_date;

  Movie(
      {required this.id,
      required this.overview,
      required this.poster_path,
      required this.release_date,
      required this.vote_average,
      required this.title});

  factory Movie.empty() {
    return Movie(
        id: 0,
        overview: '',
        poster_path: '',
        release_date: '',
        title: '',
        vote_average: '0');
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      overview: json['overview'],
      poster_path:
          'https://image.tmdb.org/t/p/w600_and_h900_bestv2/${json['poster_path']}',
      release_date: json['release_date'],
      title: json['title'],
      vote_average: json['vote_average'].toString(),
    );
  }
}
