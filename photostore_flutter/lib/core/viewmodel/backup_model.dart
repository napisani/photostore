import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/backup_stats.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/service/backup_services.dart';
import 'package:photostore_flutter/locator.dart';

class BackupModel with ChangeNotifier {
  List<AgnosticMedia> queuedPhotos;

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

  Future<void> load() async {
    try {
      this.stats = await this._backupService.getPhotoBackupStats();
    } catch (err) {
      print('[BackupModel] got error in load ${err.toString()}');
      this.stats = null;
      this.screenStatus = ScreenStatus.error(err.toString());
    }
    notifyListeners();
  }
}
