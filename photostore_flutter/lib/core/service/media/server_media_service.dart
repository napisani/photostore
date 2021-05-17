import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/core/model/photo_date_ranges.dart';
import 'package:photostore_flutter/core/model/photo_diff_request.dart';
import 'package:photostore_flutter/core/model/photo_diff_result.dart';
import 'package:photostore_flutter/core/repository/photo/media_api_repository.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_service.dart';

class ServerMediaService extends AbstractPhotoPageService {
  ServerMediaService() : super(mediaRepo: locator<MediaAPIRepository>());

  Future<Photo> getLastBackedUpPhoto() async {
    return await (mediaRepo as MediaAPIRepository).getLastBackedUpPhoto();
  }

  Future<Photo> uploadPhoto(MobilePhoto photo) async {
    return await (mediaRepo as MediaAPIRepository).uploadPhoto(photo);
  }

  Future<void> deletePhotosByDeviceID({String deviceId}) async {
    return await (mediaRepo as MediaAPIRepository)
        .deletePhotosByDeviceID(deviceId: deviceId);
  }

  Future<void> deletePhotosByID({String id}) async {
    return await (mediaRepo as MediaAPIRepository)
        .deletePhoto(id: id);
  }

  Future<List<PhotoDiffResult>> diffPhotos(List<AgnosticMedia> photos) async {
    return await (mediaRepo as MediaAPIRepository).diffPhotos(
        photos.map<PhotoDiffRequest>((p) => p.toDiffRequest()).toList());
  }

  Future<List<MediaDevice>> getDevices() async {
    return await (mediaRepo as MediaAPIRepository).getDevices();
  }

  Future<PhotoDateRanges> getPhotoDateRanges() async {
    return await (mediaRepo as MediaAPIRepository).getPhotoDateRanges();
  }

  String getOriginalFileURL(String photoId) => (mediaRepo as MediaAPIRepository)
      .getOriginalFileURL(photoId, withAPIKey: true);

  String getFullsizePNGURL(String photoId) => (mediaRepo as MediaAPIRepository)
      .getFullsizePNGURL(photoId, withAPIKey: true);

  String getThumbnailURL(String photoId) => (mediaRepo as MediaAPIRepository)
      .getThumbnailURL(photoId, withAPIKey: true);
}
