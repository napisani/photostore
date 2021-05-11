import 'package:photostore_flutter/core/repository/photo/media_mobile_repository.dart';
import 'package:photostore_flutter/core/service/media/abstract_photo_page_service.dart';
import 'package:photostore_flutter/locator.dart';

class MobileMediaService extends AbstractPhotoPageService {
  MobileMediaService() : super(mediaRepo: locator<MediaMobileRepository>());

}
