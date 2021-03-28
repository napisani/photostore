import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _AppSettingKeys {
  static const serverIP = 'serverIP';
  static const serverPort = 'serverPort';
  static const https = 'https';
  static const deviceID = 'deviceID';
  static const apiKey = 'apiKey';
  static const batchSize = 'batchSize';
  static const itemsPerPage = 'itemsPerPage';

  static const uploadRetryAttempts = 'uploadRetryAttempts';
  static const connectTimeout = 'connectTimeout';
  static const receiveTimeout = 'receiveTimeout';
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

    success =
        await prefs.setString(_AppSettingKeys.deviceID, settings.deviceID);
    _checkAndThrow(success, _AppSettingKeys.deviceID);
    success = await prefs.setString(_AppSettingKeys.apiKey, settings.apiKey);
    _checkAndThrow(success, _AppSettingKeys.apiKey);

    success = await prefs.setInt(_AppSettingKeys.batchSize, settings.batchSize);
    _checkAndThrow(success, _AppSettingKeys.batchSize);

    success = await prefs.setInt(_AppSettingKeys.itemsPerPage, settings.itemsPerPage);
    _checkAndThrow(success, _AppSettingKeys.itemsPerPage);

    success = await prefs.setInt(
        _AppSettingKeys.uploadRetryAttempts, settings.uploadRetryAttempts);
    _checkAndThrow(success, _AppSettingKeys.uploadRetryAttempts);

    success = await prefs.setInt(
        _AppSettingKeys.connectTimeout, settings.connectTimeout);
    _checkAndThrow(success, _AppSettingKeys.connectTimeout);
    success = await prefs.setInt(
        _AppSettingKeys.receiveTimeout, settings.receiveTimeout);
    _checkAndThrow(success, _AppSettingKeys.receiveTimeout);
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
      serverIP: prefs.getString(_AppSettingKeys.serverIP) ?? '192.168.1.100',
      serverPort: prefs.getInt(_AppSettingKeys.serverPort) ?? 5000,
      https: prefs.getBool(_AppSettingKeys.https) ?? false,
      deviceID:
          prefs.getString(_AppSettingKeys.deviceID) ?? (await _getDeviceId()),
      apiKey: prefs.getString(_AppSettingKeys.apiKey) ?? '',
      batchSize: prefs.getInt(_AppSettingKeys.batchSize) ?? 5,
      itemsPerPage: prefs.getInt(_AppSettingKeys.itemsPerPage) ?? 25,
      uploadRetryAttempts:
          prefs.getInt(_AppSettingKeys.uploadRetryAttempts) ?? 2,
      connectTimeout: prefs.getInt(_AppSettingKeys.connectTimeout) ?? 60,
      receiveTimeout: prefs.getInt(_AppSettingKeys.receiveTimeout) ?? 60,
    );
  }

  Future<String> _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
    return 'web_device_${DateTime.now().millisecondsSinceEpoch}';
  }
}
