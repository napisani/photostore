import 'package:photostore_flutter/models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _AppSettingKeys {
  static const serverIP = 'serverIP';
  static const serverPort = 'serverPort';
  static const https = 'https';
}

class SettingsRepository {
  Future<AppSettings> saveSettings(AppSettings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success =
        await prefs.setString(_AppSettingKeys.serverIP, settings.serverIP);
    _checkAndThrow(success, _AppSettingKeys.serverIP);
    success =
        await prefs.setInt(_AppSettingKeys.serverPort, settings.serverPort);
    _checkAndThrow(success, _AppSettingKeys.serverPort);
    success = await prefs.setBool(_AppSettingKeys.https, settings.https);
    _checkAndThrow(success, _AppSettingKeys.https);
    return await getSettings();
  }

  _checkAndThrow(bool success, String property) {
    if (!success) {
      throw new Exception("failed to get settings property: $property ");
    }
  }

  Future<AppSettings> getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return AppSettings(
        prefs.getString(_AppSettingKeys.serverIP) ?? '192.168.1.100',
        prefs.getInt(_AppSettingKeys.serverPort) ?? 5000,
        prefs.getBool(_AppSettingKeys.https) ?? false);
  }
}
