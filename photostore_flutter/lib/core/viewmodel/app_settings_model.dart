import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_view_model.dart';

class AppSettingsModel extends AbstractViewModel {
  ScreenStatus status = ScreenStatus.uninitialized();
  AppSettings appSettings;

  final AppSettingsService _appSettingsService = locator<AppSettingsService>();

  AppSettingsModel(): super() {
    reinit();
  }

  save(AppSettings newAppSettings) async {
    status = ScreenStatus.loading(this);
    notifyListeners();
    try {
      appSettings = await _appSettingsService.saveSettings(newAppSettings);
      status = ScreenStatus.success();
    } catch (err, s) {
      status = ScreenStatus.error(err.toString());
      print('AppSettingsModel:save failed to save: $err, stack: $s');
    }
    notifyListeners();
  }

  reinit() {
    status = ScreenStatus.uninitialized();
    appSettings = this._appSettingsService.currentAppSettings;
    if (appSettings != null) {
      status = ScreenStatus.success();
    }
    notifyListeners();
  }
}
