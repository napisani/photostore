import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/media/server_media_service.dart';
import 'package:photostore_flutter/core/viewmodel/abstract_view_model.dart';
import 'package:photostore_flutter/locator.dart';

class DeviceManagementModel extends AbstractViewModel {
  ScreenStatus status = ScreenStatus.uninitialized();
  ServerMediaService _serverMediaService = locator<ServerMediaService>();
  List<MediaDevice> devices = [];

  // AppSettings appSettings;
  //
  // final AppSettingsService _appSettingsService = locator<AppSettingsService>();

  DeviceManagementModel() : super() {
    reinit();
  }

  // save(AppSettings newAppSettings) async {
  //   status = ScreenStatus.loading(this);
  //   notifyListeners();
  //   try {
  //     appSettings = await _appSettingsService.saveSettings(newAppSettings);
  //     status = ScreenStatus.success();
  //   } catch (err, s) {
  //     status = ScreenStatus.error(err.toString());
  //     print('AppSettingsModel:save failed to save: $err, stack: $s');
  //   }
  //   notifyListeners();
  // }

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
      devices = await _serverMediaService.getDevices();
      status = ScreenStatus.success();
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

    // appSettings = this._appSettingsService.currentAppSettings;
    // if (appSettings != null) {
    //   status = ScreenStatus.success();
    // }
    await loadDevices();
  }
}
