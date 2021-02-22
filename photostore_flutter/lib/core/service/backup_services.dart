import 'package:photostore_flutter/core/model/backup_stats.dart';
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

  void dispose() {}
}
