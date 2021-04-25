import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/service/media/server_media_service.dart';
import 'package:photostore_flutter/core/viewmodel/abstract_view_model.dart';
import 'package:photostore_flutter/locator.dart';

class DeviceManagementModel extends AbstractViewModel {
  ServerMediaService _serverMediaService = locator<ServerMediaService>();
  AppSettingsService _appSettingsService = locator<AppSettingsService>();

  List<MediaDevice> devices = [];

  DeviceManagementModel() : super() {
    reinit();
  }

  Future<void> deletePhotos(String deviceId) async {
    this.screenStatus = ScreenStatus.loading(this);
    notifyListeners();
    try {
      await _serverMediaService.deletePhotosByDeviceID(deviceId: deviceId);
      this.screenStatus = ScreenStatus.success();
    } catch (err, s) {
      print('[BackupModel] got error in deletePhotos ${err.toString()} $s');
      this.screenStatus = ScreenStatus.error(err.toString());
    }
    reinit();
    notifyListeners();
  }

  Future<void> loadDevices() async {
    status = ScreenStatus.loading(this);
    try {
      if (this._appSettingsService.areServerSettingsConfigured()) {
        devices = await _serverMediaService.getDevices();
        status = ScreenStatus.success();
      } else {
        status = ScreenStatus.disabled(DISABLED_SERVER_FEATURE_TEXT);
      }
    } catch (err, s) {
      print(
          '[DeviceManagementModel] got error in loadDevices ${err.toString()} $s');
      status = ScreenStatus.error(err.toString());
    }
    notifyListeners();
  }

  Future<void> reinit() async {
    devices = [];
    status = ScreenStatus.uninitialized();
    await loadDevices();
  }
}
