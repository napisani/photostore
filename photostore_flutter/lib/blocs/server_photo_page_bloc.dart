import 'package:photostore_flutter/blocs/abstract_photo_page_bloc.dart';
import 'package:photostore_flutter/services/media_repository.dart';

import 'app_settings_bloc.dart';

class ServerPhotoPageBloc extends AbstractPhotoPageBloc {
  ServerPhotoPageBloc(
      MediaRepository mediaRepo, AppSettingsBloc appSettingsBloc)
      : super(mediaRepo: mediaRepo, appSettingsBloc: appSettingsBloc);
}
