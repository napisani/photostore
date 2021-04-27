import 'package:dio/dio.dart';
import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/utils/api_key_utils.dart';
import 'package:photostore_flutter/locator.dart';

class HTTPService {
  Dio _httpClient;
  final AppSettingsService _appSettingsService = locator<AppSettingsService>();

  HTTPService() {
    _registerAppSettingsListener();
  }

  _registerAppSettingsListener() {
    _appSettingsService.appSettingsAsStream.listen((AppSettings appSettings) {
      if (_httpClient != null) {
        try {
          _httpClient.close();
        } catch (ex, s) {
          print(
              'ran into an error closing dio http client error: $ex stack: $s');
        }
      }
      print('created new Dio with new BaseOptions');
      this._httpClient = Dio(_getBaseOptions(appSettings));
    });
  }

  Dio getHttpClient() => _httpClient;

  BaseOptions _getBaseOptions(AppSettings appSettings) => BaseOptions(
      connectTimeout: appSettings.connectTimeout * 1000,
      //seconds to milliseconds
      receiveTimeout:
          appSettings.receiveTimeout * 1000, //seconds to milliseconds
      headers: {ACCESS_TOKEN_KEY: appSettings.apiKey});

  dispose() {
    try {
      _httpClient.close();
    } catch (_) {}
  }
}
