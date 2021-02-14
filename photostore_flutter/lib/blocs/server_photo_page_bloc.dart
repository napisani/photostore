import 'package:photostore_flutter/blocs/abstract_photo_page_bloc.dart';
import 'package:photostore_flutter/services/media_repository.dart';


class ServerPhotoPageBloc extends AbstractPhotoPageBloc {
  ServerPhotoPageBloc(
      MediaRepository mediaRepo)
      : super(mediaRepo: mediaRepo);
}
