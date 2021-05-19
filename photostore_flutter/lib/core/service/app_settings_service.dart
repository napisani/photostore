import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/core/repository/settings_repository.dart';
import 'package:photostore_flutter/locator.dart';
import 'package:rxdart/rxdart.dart';

class AppSettingsService {
  final SettingsRepository _settingsRepository = locator<SettingsRepository>();
  final BehaviorSubject<AppSettings> _currentSettings =
  BehaviorSubject<AppSettings>();

  AppSettingsService() {
  }

  AppSettings get currentAppSettings => _currentSettings.value;

  Future<AppSettings> loadSettings(double width, double height) async {
    AppSettings settings = await this._settingsRepository.getSettings();
    settings = settings.cloneWith(deviceWidth: width, deviceHeight: height);
    this._currentSettings.sink.add(settings);
    return settings;
  }

  Future<AppSettings> saveSettings(AppSettings settings) async {
    final AppSettings settingsSaved =
    await this._settingsRepository.saveSettings(settings);
    this._currentSettings.sink.add(settingsSaved);
    return settingsSaved;
  }

  bool areServerSettingsConfigured() =>
      this.currentAppSettings?.serverIP != ''
          && this.currentAppSettings?.serverIP != null;

  Stream<AppSettings> get appSettingsAsStream => _currentSettings.stream;

  void dispose() {
    _currentSettings.close();
  }
}
