import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/backup_stats.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/core/model/photo_diff_result.dart';
import 'package:photostore_flutter/core/service/mobile_media_service.dart';
import 'package:photostore_flutter/core/service/server_media_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'app_settings_service.dart';

class BackupService {
  final AppSettingsService _appSettingsService = locator<AppSettingsService>();
  final ServerMediaService _serverMediaService = locator<ServerMediaService>();
  final MobileMediaService _mobileMediaService = locator<MobileMediaService>();

  BackupService() {}

  Future<BackupStats> getPhotoBackupStats() async {
    Photo photo = await this._serverMediaService.getLastBackedUpPhoto();
    int count = await this._serverMediaService.getPhotoCount();
    BackupStats stats = BackupStats(
        backedUpPhotoCount: count,
        lastBackedUpPhotoId: photo.id,
        lastBackedUpPhotoModifyDate: photo.creationDate);
    return stats;
  }

  Future<List<MobilePhoto>> getBackupQueueUsingDate(
      DateTime lastBackedUpDate) async {
    Pagination<AgnosticMedia> queuedPhotos = Pagination<AgnosticMedia>();
    while (queuedPhotos.hasMorePages) {
      Pagination<AgnosticMedia> morePhotos =
          await _mobileMediaService.loadPage(queuedPhotos.page + 1);
      final int previousCount = morePhotos.items.length;
      print('previousCount $previousCount lastBackedUpDate: $lastBackedUpDate');

      morePhotos.items.removeWhere(
          (element) => element.creationDate.compareTo(lastBackedUpDate) <= 0);
      final bool done = previousCount != morePhotos.items.length;
      queuedPhotos = morePhotos;
      // queuedPhotos = Pagination.combineWith(queuedPhotos, morePhotos);
      if (done) {
        break;
      }
    }
    print('queuedPhotos.items ${queuedPhotos.items.length}');
    return List<MobilePhoto>.from(queuedPhotos.items);
  }

  Future<List<MobilePhoto>> getFullBackupQueue() async {
    List<AgnosticMedia> queuedPhotos = [];
    // Pagination<MobilePhoto> queuedPhotos = Pagination<MobilePhoto>();
    for (int page = 1; page > 0; page++) {
      Pagination<AgnosticMedia> morePhotos =
          await _mobileMediaService.loadPage(page);

      List<PhotoDiffResult> results =
          await _serverMediaService.diffPhotos(morePhotos.items);
      Map<String, PhotoDiffResult> resultsMap = Map.fromIterable(results,
          key: (res) => res.nativeId, value: (res) => res);
      morePhotos.items.removeWhere((AgnosticMedia photo) =>
          resultsMap[photo.nativeId].exists &&
          resultsMap[photo.nativeId].sameDate);
      queuedPhotos.addAll(morePhotos.items);
      if (!morePhotos.hasMorePages) {
        break;
      }
    }
    print('queuedPhotos ${queuedPhotos.length}');
    return List<MobilePhoto>.from(queuedPhotos);
  }

  Future<void> doBackup(List<MobilePhoto> queueIn) async {
    final int batchSize = _appSettingsService.currentAppSettings.batchSize;
    List<MobilePhoto> queue = [...queueIn];
    queue.sort((a, b) {
      return a.modifiedDate.compareTo(b.modifiedDate);
    });
    print('doBackup');
    List<MobilePhoto> batch = [];
    for (MobilePhoto photo in queue) {
      if (photo.assetType != 1) {
        print('not a photo - skipping');
      } else {
        batch.add(photo);
      }
      if (batch.length == batchSize) {
        await _backupBatch(batch);
        batch.clear();
      }
    }
    await _backupBatch(batch);
    print('doBackup - done!');
  }

  Future<void> _backupBatch(List<MobilePhoto> batch) async {
    if (batch.isNotEmpty) {
      try {
        await Future.wait(batch
            .map((p) async => await _serverMediaService.uploadPhoto(p))
            .toList());
      } catch (e, s) {
        print('an error occurred uploading photo e: $e stack: $s ');
      }
    }
  }

  void dispose() {}
}
