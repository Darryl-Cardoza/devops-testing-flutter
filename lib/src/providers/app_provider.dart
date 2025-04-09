import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter_movie_deep_dive_test/src/services/services.dart';
import 'package:provider/provider.dart';

class AppProvider extends StatelessWidget {
  final Client httpClient;
  final Widget child;

  const AppProvider({Key? key,
    required this.httpClient,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppService>(create: (_) => AppService(httpClient)),
      ],
      child: child,
    );
  }
}
