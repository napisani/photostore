import 'dart:async';

import 'package:photostore_flutter/core/model/backup_stats.dart';
import 'package:photostore_flutter/core/model/cancel_notifier.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/service/backup_services.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_view_model.dart';

class BackupModel extends AbstractViewModel {
  List<MobilePhoto> queuedPhotos;
  ScreenStatus screenStatus = ScreenStatus.uninitialized();
  BackupStats stats;
  bool backupFinished = false;
  CancelNotifier cancelNotifier;
  final BackupService _backupService = locator<BackupService>();

  final AppSettingsService _appSettingsService = locator<AppSettingsService>();

  BackupModel() : super() {
    _registerAppSettingsListener();
    this.reinit();
  }

  void _registerAppSettingsListener() {
    this._appSettingsService.appSettingsAsStream.listen((event) {
      reinit();
    });
  }

  void reinit() async {
    this.screenStatus = ScreenStatus.uninitialized();
    this.queuedPhotos = null;
    this.cancelNotifier = null;
    this.stats = null;
    backupFinished = false;
    if (this._appSettingsService.currentAppSettings != null) {
      await loadBackupStats();
    } else {
      notifyListeners();
    }
  }

  Future<void> loadBackupStats() async {
    this.screenStatus = ScreenStatus.loading(this);
    notifyListeners();
    try {
      this.stats = await this._backupService.getPhotoBackupStats();
      this.screenStatus = ScreenStatus.success();
    } catch (err, s) {
      print(
          '[BackupModel] got error in loadBackupStats ${err.toString()} stack: $s');
      this.stats = null;
      this.screenStatus = ScreenStatus.error(err.toString());
    }
    notifyListeners();
  }

  Future<void> loadIncrementalBackupQueue() async {
    this.backupFinished = false;
    this.screenStatus = ScreenStatus.loading(this);
    notifyListeners();
    try {
      this.cancelNotifier = CancelNotifier();
      queuedPhotos = await _backupService.getBackupQueueUsingDate(
          stats.lastBackedUpPhotoModifyDate,
          canceller: cancelNotifier);
      if (cancelNotifier.hasBeenCancelled) {
        reinit();
      } else {
        this.screenStatus = ScreenStatus.success();
        cancelNotifier = null;
      }
    } catch (err, s) {
      print(
          '[BackupModel] got error in loadIncrementalBackupQueue ${err.toString()} $s');
      queuedPhotos = null;
      this.screenStatus = ScreenStatus.error(err.toString());
      cancelNotifier = null;
    }
    notifyListeners();
  }

  Future<void> loadFullBackupQueue() async {
    this.backupFinished = false;
    this.screenStatus = ScreenStatus.loading(this);
    notifyListeners();
    try {
      this.cancelNotifier = CancelNotifier();
      queuedPhotos =
          await _backupService.getFullBackupQueue(canceller: cancelNotifier);
      if (cancelNotifier.hasBeenCancelled) {
        reinit();
      } else {
        this.screenStatus = ScreenStatus.success();
        cancelNotifier = null;
      }
    } catch (err, s) {
      print(
          '[BackupModel] got error in loadFullBackupQueue ${err.toString()} stack: $s');
      queuedPhotos = null;
      this.screenStatus = ScreenStatus.error(err.toString());
      cancelNotifier = null;
    }
    notifyListeners();
  }

  Future<void> doBackup() async {
    this.screenStatus = ScreenStatus.loading(this);
    notifyListeners();
    try {
      this.cancelNotifier = CancelNotifier();
      await _backupService.doBackup(queuedPhotos, canceller: cancelNotifier,
          progressNotify: (int orig, int newCnt) {
        print('inside progressNotify');
        final String progressText = 'Backed up ${orig - newCnt} of $orig total';
        this.screenStatus = ScreenStatus.loading(this,
            percent: ((orig - newCnt)) / orig, progressText: progressText);
        notifyListeners();
      });
      if (cancelNotifier.hasBeenCancelled) {
        reinit();
      } else {
        this.screenStatus = ScreenStatus.success();
        this.backupFinished = true;
        this.queuedPhotos = null;
        this.loadBackupStats();
      }
    } catch (err, s) {
      print('[BackupModel] got error in doBackup ${err.toString()}, stack: $s');
      this.screenStatus = ScreenStatus.error(err.toString());
      this.cancelNotifier = null;
    }
    notifyListeners();
  }
}
