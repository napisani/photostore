import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/screens/photo_list_widget.dart';
import 'package:photostore_flutter/services/media_mobile_repository.dart';
import 'package:photostore_flutter/services/media_repository.dart';
import 'package:photostore_flutter/services/mock_media_repository.dart';

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
              title: Text('Photos'),
            ),
            body: RepositoryProvider<MediaRepository>(
              create: (context) => MediaMobileRepository(),
              child: PhotoListTabWidget(),
            )));
  }
}
