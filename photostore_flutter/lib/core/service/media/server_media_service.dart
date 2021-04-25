import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/core/model/photo_diff_request.dart';
import 'package:photostore_flutter/core/model/photo_diff_result.dart';
import 'package:photostore_flutter/core/repository/media_api_repository.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_service.dart';

class ServerMediaService extends AbstractPhotoPageService {
  ServerMediaService() : super(mediaRepo: locator<MediaAPIRepository>());

  Future<Photo> getLastBackedUpPhoto() async {
    return (mediaRepo as MediaAPIRepository).getLastBackedUpPhoto();
  }

  Future<Photo> uploadPhoto(MobilePhoto photo) async {
    return (mediaRepo as MediaAPIRepository).uploadPhoto(photo);
  }

  Future<void> deletePhotosByDeviceID({String deviceId}) async {
    return (mediaRepo as MediaAPIRepository)
        .deletePhotosByDeviceID(deviceId: deviceId);
  }

  Future<List<PhotoDiffResult>> diffPhotos(List<AgnosticMedia> photos) async {
    return (mediaRepo as MediaAPIRepository).diffPhotos(
        photos.map<PhotoDiffRequest>((p) => p.toDiffRequest()).toList());
  }

  Future<List<MediaDevice>> getDevices() async {
    return (mediaRepo as MediaAPIRepository).getDevices();
  }
}
