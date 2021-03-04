import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/backup_stats.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/core/service/mobile_media_service.dart';
import 'package:photostore_flutter/core/service/server_media_service.dart';
import 'package:photostore_flutter/locator.dart';

class BackupService {
  final ServerMediaService _serverMediaService = locator<ServerMediaService>();
  final MobileMediaService _mobileMediaService = locator<MobileMediaService>();

  Future<BackupStats> getPhotoBackupStats() async {
    Photo photo = await this._serverMediaService.getLastBackedUpPhoto();
    BackupStats stats = BackupStats(
        lastBackedUpPhotoId: photo.id,
        lastBackedUpPhotoCreateDate: photo.creationDate);
    return stats;
  }

  Future<List<MobilePhoto>> getBackupQueue(DateTime lastBackedUpDate) async {
    Pagination<MobilePhoto> queuedPhotos = Pagination<MobilePhoto>();
    while (queuedPhotos.hasMorePages) {
      Pagination<MobilePhoto> morePhotos = await _mobileMediaService.loadPage(
          queuedPhotos.page + 1);
      final int previousCount = morePhotos.items.length;
      print('previousCount $previousCount lastBackedUpDate: $lastBackedUpDate');

      morePhotos.items.removeWhere((element) =>
      element.creationDate
          .compareTo(lastBackedUpDate) <=
          0);
      final bool done = previousCount != morePhotos.items.length;
      queuedPhotos = Pagination.combineWith(queuedPhotos, morePhotos);
      if (done) {
        break;
      }
    }
    print('queuedPhotos.items ${queuedPhotos.items.length}');
    return queuedPhotos.items;
  }


  Future<void> doBackup(List<MobilePhoto> queue) async {
    print('doBackup');
    for(MobilePhoto photo in queue){
      await _serverMediaService.uploadPhoto(photo);
    }
  }

  void dispose() {}
}
