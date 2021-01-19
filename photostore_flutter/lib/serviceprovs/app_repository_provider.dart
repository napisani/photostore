import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/services/media_api_repository.dart';
import 'package:photostore_flutter/services/media_mobile_repositoryV2.dart';

class AppRepositoryProvider extends StatelessWidget {
  final Widget child;

  AppRepositoryProvider({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<MediaMobileRepositoryV2>(
        create: (context) => MediaMobileRepositoryV2(),
      ),
      RepositoryProvider<MediaAPIRepository>(
        create: (context) => MediaAPIRepository(),
      )
    ], child: child);
  }

}

