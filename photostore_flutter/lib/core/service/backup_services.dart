import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/backup_stats.dart';
import 'package:photostore_flutter/core/model/cancel_notifier.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/core/model/photo_diff_result.dart';
import 'package:photostore_flutter/core/model/progress_log.dart';
import 'package:photostore_flutter/core/service/mobile_media_service.dart';
import 'package:photostore_flutter/core/service/server_media_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'app_settings_service.dart';

typedef BackupProgressHandler = Function(int originalCount, int queueCount);

class BackupService {
  final AppSettingsService _appSettingsService = locator<AppSettingsService>();
  final ServerMediaService _serverMediaService = locator<ServerMediaService>();
  final MobileMediaService _mobileMediaService = locator<MobileMediaService>();

  BackupService();

  Future<BackupStats> getPhotoBackupStats() async {
    Photo photo = await this._serverMediaService.getLastBackedUpPhoto();
    int backupCount = await this._serverMediaService.getPhotoCount();
    int mobileCount = await this._mobileMediaService.getPhotoCount();
    BackupStats stats = BackupStats(
        backedUpPhotoCount: backupCount,
        mobilePhotoCount: mobileCount,
        lastBackedUpPhotoId: photo.id,
        lastBackedUpPhotoModifyDate: photo.creationDate);
    return stats;
  }

  Future<List<MobilePhoto>> getBackupQueueUsingDate(DateTime lastBackedUpDate,
      {canceller: CancelNotifier}) async {
    Pagination<AgnosticMedia> queuedPhotos = Pagination<AgnosticMedia>();
    while (queuedPhotos.hasMorePages) {
      if (canceller != null && canceller.hasBeenCancelled) {
        print('cancelled getFullBackupQueue');
        return [];
      }

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

  Future<List<MobilePhoto>> getFullBackupQueue(
      {canceller: CancelNotifier}) async {
    List<AgnosticMedia> queuedPhotos = [];
    // Pagination<MobilePhoto> queuedPhotos = Pagination<MobilePhoto>();
    for (int page = 1; page > 0; page++) {
      if (canceller != null && canceller.hasBeenCancelled) {
        print('cancelled getFullBackupQueue');
        return [];
      }

      Pagination<AgnosticMedia> morePhotos =
          await _mobileMediaService.loadPage(page);

      List<PhotoDiffResult> results =
          await _serverMediaService.diffPhotos(morePhotos.items);
      Map<String, PhotoDiffResult> resultsMap = Map.fromIterable(results,
          key: (res) => res.nativeId, value: (res) => res);
      morePhotos.items.removeWhere((AgnosticMedia photo) =>
          resultsMap[photo.nativeId].exists &&
          resultsMap[photo.nativeId].sameDate);
      if (!morePhotos.hasMorePages) {
        queuedPhotos.addAll(morePhotos.items);
        break;
      }
    }
    print('queuedPhotos ${queuedPhotos.length}');
    return List<MobilePhoto>.from(queuedPhotos);
  }

  ProgressStats _buildBackupStatFromPhoto(AgnosticMedia media) {
    ProgressStats stats =
        ProgressStats(id: media.id, status: "Backup in Progress...");
    return stats;
  }

  Future<void> doBackup(List<MobilePhoto> queueIn,
      {BackupProgressHandler progressNotify,
      CancelNotifier canceller,
      ProgressLog progressLog}) async {
    final BackupProgressHandler progressNotifySafe = (orig, newCnt) {
      if (progressNotify != null) {
        progressNotify(orig, newCnt);
      }
    };

    final int batchSize = _appSettingsService.currentAppSettings.batchSize;
    List<MobilePhoto> queue = [...queueIn];
    queue.sort((a, b) {
      return a.modifiedDate.compareTo(b.modifiedDate);
    });
    print('doBackup');
    final origSize = queue.length;
    progressNotifySafe(origSize, origSize);
    List<MobilePhoto> batch = [];
    int uploadCount = 0;
    for (MobilePhoto photo in queue) {
      // if (photo.assetType != 1) {
      // print('not a photo - skipping');
      // } else {
      batch.add(photo);
      // }
      if (batch.length == batchSize) {
        if (canceller != null && canceller.hasBeenCancelled) {
          print('cancelled doBackup');
          return;
        }
        await _backupBatch(batch, progressLog: progressLog);
        uploadCount += batch.length;
        progressNotifySafe(origSize, origSize - uploadCount);

        batch.clear();
      }
    }
    if (canceller != null && canceller.hasBeenCancelled) {
      print('cancelled doBackup');
      return;
    }
    await _backupBatch(batch);
    uploadCount += batch.length;
    progressNotifySafe(origSize, origSize - uploadCount);
    print('doBackup - done!');
  }

  Future<void> _backupBatch(List<MobilePhoto> batch,
      {ProgressLog progressLog}) async {
    if (batch.isNotEmpty) {
      List<ProgressStats> stats =
          batch.map((media) => _buildBackupStatFromPhoto(media)).toList();
      progressLog?.addAll(stats);
      try {
        await Future.wait(batch
            .map((p) async => await _serverMediaService.uploadPhoto(p))
            .toList());

        stats.forEach((stat) {
          stat.updateStatus("DONE");
        });
      } catch (e, s) {
        print('an error occurred uploading photo e: $e stack: $s ');
        stats.forEach((stat) {
          stat.updateStatus("Error: $e");
        });
      }
    }
  }

  void dispose() {}
}
