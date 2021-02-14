import 'package:photostore_flutter/services/media_repository.dart';

import 'abstract_photo_page_bloc.dart';
import 'app_settings_bloc.dart';

class MobilePhotoPageBloc extends AbstractPhotoPageBloc {
  MobilePhotoPageBloc(
      MediaRepository mediaRepo)
      : super(mediaRepo: mediaRepo);
}
