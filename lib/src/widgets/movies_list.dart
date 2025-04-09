import 'package:flutter/material.dart';
import 'package:flutter_movie_deep_dive_test/src/models/models.dart';
import 'package:flutter_movie_deep_dive_test/src/widgets/movie_card.dart';

class MoviesList extends StatelessWidget {
  final MoviesResponse response;

  const MoviesList({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movies = response.movies;
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        Movie movie = movies[index];
        return MovieCard(
          key: Key("${movie.id}"),
          data: movie,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
