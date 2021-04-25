import 'dart:async';

import 'package:photostore_flutter/core/model/backup_stats.dart';
import 'package:photostore_flutter/core/model/cancel_notifier.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/progress_log.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/service/backup_services.dart';
import 'package:photostore_flutter/core/service/lockout_service.dart';
import 'package:photostore_flutter/core/service/media/mobile_media_service.dart';
import 'package:photostore_flutter/core/viewmodel/tab_view_model_mixin.dart';
import 'package:photostore_flutter/locator.dart';
import 'package:wakelock/wakelock.dart';

import 'abstract_view_model.dart';

class BackupModel extends AbstractViewModel with TabViewModelMixin {
  List<MobilePhoto> queuedPhotos;
  ScreenStatus screenStatus = ScreenStatus.uninitialized();
  BackupStats stats;
  final ProgressLog progressLog = new ProgressLog();
  bool backupFinished = false;
  CancelNotifier cancelNotifier;

  final BackupService _backupService = locator<BackupService>();
  final MobileMediaService _mobileMediaService = locator<MobileMediaService>();
  final AppSettingsService _appSettingsService = locator<AppSettingsService>();
  final LockoutService _lockoutService = locator<LockoutService>();

  BackupModel() : super() {
    _registerAppSettingsListener();
    this.reinit();
  }

  void _registerAppSettingsListener() {
    addSubscription(
        this._appSettingsService.appSettingsAsStream.listen((event) {
      reinit();
    }));
  }

  void reinit() async {
    this.screenStatus = ScreenStatus.uninitialized();
    this.progressLog.clear();
    this.queuedPhotos = null;
    this.cancelNotifier = null;
    this.stats = null;
    backupFinished = false;
    _mobileMediaService.reset();
    if (this._appSettingsService.areServerSettingsConfigured()) {
      await loadBackupStats();
    } else {
      this.screenStatus = ScreenStatus.disabled(DISABLED_SERVER_FEATURE_TEXT);
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
    this.progressLog.clear();
    this.screenStatus = ScreenStatus.loading(this);
    notifyListeners();
    Wakelock.toggle(enable: true);
    _lockoutService.establishAllLockout();
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
    Wakelock.toggle(enable: false);
    _lockoutService.clearLockout();
    notifyListeners();
  }

  Future<void> loadFullBackupQueue() async {
    this.backupFinished = false;
    this.progressLog.clear();
    this.screenStatus = ScreenStatus.loading(this);
    notifyListeners();
    Wakelock.toggle(enable: true);
    _lockoutService.establishAllLockout();

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
    _lockoutService.clearLockout();
    Wakelock.toggle(enable: false);
    notifyListeners();
  }

  Future<void> doBackup() async {
    this.progressLog.clear();
    this.screenStatus = ScreenStatus.loading(this);
    _lockoutService.establishAllLockout();
    Wakelock.toggle(enable: true);
    notifyListeners();
    try {
      this.cancelNotifier = CancelNotifier();
      await _backupService.doBackup(queuedPhotos,
          canceller: cancelNotifier, progressLog: this.progressLog,
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
    _lockoutService.clearLockout();
    Wakelock.toggle(enable: false);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    progressLog.dispose();
  }

  @override
  TabName getTabName() => TabName.BACKUP;
}
