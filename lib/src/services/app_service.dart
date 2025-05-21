import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movie_deep_dive_test/src/models/models.dart';
import 'package:http/http.dart' show Client;

class LoadMoviesException implements Exception {
  final message;

  LoadMoviesException(this.message);
}

class AppService {
  final Client client;

  AppService(this.client);

  Future<MoviesResponse> loadMovies() async {
    final apiKey = dotenv.env['API_KEY'];
    final api = dotenv.env['API_NAME'];
    final urlPath = 'movie/now_playing';
    final path = '$api/$urlPath?api_key=$apiKey&language=en-US';

    // appel asynchrone
    final response = await client.get(Uri.parse(path));

    if (response.statusCode != 200) {
      throw LoadMoviesException('LoadMovies - Request Error: ${response.statusCode}');
    }

    // Décoder le contenu de la response ici
    final data = json.decode(response.body);

    return MoviesResponse.fromJson(data);
  }
}
