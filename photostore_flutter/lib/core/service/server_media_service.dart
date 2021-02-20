import 'package:photostore_flutter/core/repository/media_api_repository.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_service.dart';

class ServerMediaService extends AbstractPhotoPageService {
  ServerMediaService() : super(mediaRepo: locator<MediaAPIRepository>());
}
