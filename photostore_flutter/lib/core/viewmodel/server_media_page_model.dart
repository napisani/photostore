import 'package:photostore_flutter/core/service/server_media_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_model.dart';

class ServerMediaPageModel extends AbstractPhotoPageModel {
  ServerMediaPageModel()
      : super(photoPageService: locator<ServerMediaService>());
}
