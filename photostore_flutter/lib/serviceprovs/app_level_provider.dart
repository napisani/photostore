import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:photostore_flutter/blocs/app_settings_bloc.dart';
import 'package:photostore_flutter/blocs/mobile_photo_page_bloc.dart';
import 'package:photostore_flutter/blocs/server_photo_page_bloc.dart';
import 'package:photostore_flutter/services/media_api_repository.dart';
import 'package:photostore_flutter/services/media_mobile_repositoryV2.dart';
import 'package:photostore_flutter/services/settings_repository.dart';

class AppLevelProviders extends StatelessWidget {
  final Widget child;

  AppLevelProviders({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<SettingsRepository>(
      create: (context) => SettingsRepository(),
      child: BlocProvider(
        create: (context) {
          AppSettingsBloc bloc = AppSettingsBloc(
              RepositoryProvider.of<SettingsRepository>(context));
          return bloc;
        },
        child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<MediaMobileRepositoryV2>(
                create: (context) => MediaMobileRepositoryV2(),
              ),
              RepositoryProvider<MediaAPIRepository>(
                create: (context) =>
                    MediaAPIRepository(httpClient: http.Client()),
              )
            ],
            child: MultiBlocProvider(providers: [
              BlocProvider<MobilePhotoPageBloc>(
                  create: (context) => MobilePhotoPageBloc(
                      RepositoryProvider.of<MediaMobileRepositoryV2>(context),
                      BlocProvider.of<AppSettingsBloc>(context))),
              BlocProvider<ServerPhotoPageBloc>(
                  create: (context) => ServerPhotoPageBloc(
                      RepositoryProvider.of<MediaAPIRepository>(context),
                      BlocProvider.of<AppSettingsBloc>(context)))
            ], child: child)
        ),
      ),
    );
  }
}
