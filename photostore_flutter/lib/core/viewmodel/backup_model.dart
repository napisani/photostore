import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/backup_stats.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/service/backup_services.dart';
import 'package:photostore_flutter/locator.dart';

class BackupModel with ChangeNotifier {
  List<MobilePhoto> queuedPhotos;

  ScreenStatus screenStatus = ScreenStatus.uninitialized();
  BackupStats stats;

  final BackupService _backupService = locator<BackupService>();

  final AppSettingsService _appSettingsService = locator<AppSettingsService>();

  BackupModel() {
    _registerAppSettingsListener();
  }

  void _registerAppSettingsListener() {
    this._appSettingsService.appSettingsAsStream.listen((event) {
      if (screenStatus.type != ScreenStatusType.UNINITIALIZED) {}
    });
  }

  Future<void> loadBackupStats() async {
    this.screenStatus = ScreenStatus.loading();
    notifyListeners();
    try {
      this.stats = await this._backupService.getPhotoBackupStats();
      this.screenStatus = ScreenStatus.success();
    } catch (err) {
      print('[BackupModel] got error in loadBackupStats ${err.toString()}');
      this.stats = null;
      this.screenStatus = ScreenStatus.error(err.toString());
    }
    notifyListeners();
  }

  Future<void> loadQueue() async {
    this.screenStatus = ScreenStatus.loading();
    notifyListeners();
    try {
      queuedPhotos = await _backupService
          .getBackupQueue(stats.lastBackedUpPhotoCreateDate);
      this.screenStatus = ScreenStatus.success();
    } catch (err) {
      print('[BackupModel] got error in loadQueue ${err.toString()}');
      queuedPhotos = null;
      this.screenStatus = ScreenStatus.error(err.toString());
    }
    notifyListeners();
  }

  Future<void> doBackup() async {
    this.screenStatus = ScreenStatus.loading();
    notifyListeners();
    try {
       await _backupService
          .doBackup(queuedPhotos);
      this.screenStatus = ScreenStatus.success();
    } catch (err) {
      print('[BackupModel] got error in doBackup ${err.toString()}');
      this.screenStatus = ScreenStatus.error(err.toString());
    }
    notifyListeners();
  }

}
