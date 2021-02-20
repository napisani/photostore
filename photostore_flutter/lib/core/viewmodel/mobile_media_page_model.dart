import 'package:photostore_flutter/core/service/mobile_media_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_model.dart';

class MobileMediaPageModel extends AbstractPhotoPageModel {

  MobileMediaPageModel(): super(photoPageService: locator<MobileMediaService>());

}
