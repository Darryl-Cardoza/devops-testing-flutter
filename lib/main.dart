import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter_movie_deep_dive_test/src/app.dart';
import 'package:flutter_movie_deep_dive_test/src/providers/providers.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables before running the app
  await dotenv.load(fileName: ".env");

  runApp(
    AppProvider(
      httpClient: Client(),
      child: MyApp(),
    ),
  );
}