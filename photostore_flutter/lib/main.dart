import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:photostore_flutter/screens/photo_list_widget.dart';
import 'package:photostore_flutter/services/media_api_repository.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Infinite Scroll',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Posts'),
            ),
            body: RepositoryProvider(
              create: (context) =>
                  MediaAPIRepository(httpClient: http.Client()),
              child: PhotoListTabWidget(),
            )));
  }
}
