import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movies.g.dart';

@JsonSerializable()
class MoviesResponse extends Equatable {
  final int page;

  @JsonKey(name: 'total_results')
  final int totalResults;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  @JsonKey(name: 'results')
  final List<Movie> movies;

  const MoviesResponse({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.movies,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) => _$MoviesResponseFromJson(json);

  @override
  List<dynamic> get props => [
        page,
        totalPages,
        totalResults,
        movies,
      ];
}

@JsonSerializable()
class Movie extends Equatable {
  final int? id;

  final bool? video;

  @JsonKey(name: 'vote_count')
  final int? voteCount;

  @JsonKey(name: 'vote_average')
  final double? voteAverage;

  final String? title;

  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @JsonKey(name: 'original_language')
  final String? originalLanguage;

  @JsonKey(name: 'original_title')
  final String? originalTitle;

  final bool? adult;

  final String? overview;

  @JsonKey(name: 'gender_ids')
  final List? genreIds = [];

  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  final double? popularity;

  @JsonKey(name: 'release_date')
  final String? releaseDate;

  @JsonKey(defaultValue: false)
  final bool? favorite;

  Movie({
    this.id,
    this.video,
    this.voteCount,
    this.voteAverage,
    this.title,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.adult,
    this.overview,
    this.backdropPath,
    this.popularity,
    this.releaseDate,
    this.favorite,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  @override
  List<dynamic> get props => [
        id,
        video,
        voteCount,
        voteAverage,
        title,
        posterPath,
        originalLanguage,
        originalTitle,
        adult,
        overview,
        backdropPath,
        popularity,
        releaseDate,
        favorite,
      ];

  String get posterPathResolved =>
      posterPath == null ? 'https://via.placeholder.com/300' : 'http://image.tmdb.org/t/p/w185/$posterPath';
}
