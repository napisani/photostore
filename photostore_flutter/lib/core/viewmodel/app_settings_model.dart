import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/locator.dart';

class AppSettingsModel with ChangeNotifier {
  bool initialized = false;
  bool loading = false;
  String error;
  AppSettings appSettings;

  final AppSettingsService _appSettingsService = locator<AppSettingsService>();

  AppSettingsModel() {
    appSettings = this._appSettingsService.currentAppSettings;
    if (appSettings != null) {
      initialized = true;
    }
    notifyListeners();
  }

  save(AppSettings newAppSettings) async {
    loading = true;
    notifyListeners();
    try {
      appSettings = await _appSettingsService.saveSettings(newAppSettings);
    } catch (err) {
      error = err.toString();
    }
    loading = false;
    notifyListeners();
  }
}
