import 'package:photostore_flutter/core/repository/media_mobile_repositoryV2.dart';
import 'package:photostore_flutter/core/repository/media_repository.dart';
import 'package:photostore_flutter/core/service/abstract_photo_page_service.dart';
import 'package:photostore_flutter/locator.dart';

class MobileMediaService extends AbstractPhotoPageService {
  MobileMediaService() : super(mediaRepo: locator<MediaMobileRepositoryV2>());

}
