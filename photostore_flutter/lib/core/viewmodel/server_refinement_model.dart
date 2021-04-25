import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/service/media/server_media_service.dart';
import 'package:photostore_flutter/core/service/server_refinement_service.dart';
import 'package:photostore_flutter/core/viewmodel/abstract_view_model.dart';
import 'package:photostore_flutter/locator.dart';

class ServerRefinementModel extends AbstractViewModel {
  List<MediaDevice> deviceOptions = [];
  final ServerMediaService _serverMediaService = locator<ServerMediaService>();
  final AppSettingsService _appSettingsService = locator<AppSettingsService>();
  final ServerRefinementService _serverRefinementService =
      locator<ServerRefinementService>();

  ServerRefinementModel() {
    reinit();
  }

  selectDevice(MediaDevice mediaDevice) {
    this._serverRefinementService.setDeviceFilter(mediaDevice);
    notifyListeners();
  }

  get selectedDevice => _serverRefinementService.getDeviceFilter();

  void reinit() async {
    this.screenStatus = ScreenStatus.uninitialized();
    if (this._appSettingsService.areServerSettingsConfigured()) {
      await loadMediaDeviceOptions();
    } else {
      this.screenStatus = ScreenStatus.disabled(DISABLED_SERVER_FEATURE_TEXT);
      notifyListeners();
    }
  }

  Future<void> loadMediaDeviceOptions() async {
    this.screenStatus = ScreenStatus.loading(this);
    notifyListeners();
    try {
      this.deviceOptions = await this._serverMediaService.getDevices();
      this.deviceOptions = [
        MediaDevice.allOption(
            deviceOptions.map((e) => e.count).fold(0, (p, c) => p + c)),
        ...deviceOptions
      ];
      print('built options ${deviceOptions}');
      this.screenStatus = ScreenStatus.success();
    } catch (err, s) {
      print(
          '[ServerRefinementModel] got error in loadMediaDeviceOptions ${err.toString()} stack: $s');
      this.deviceOptions = [];
      this.screenStatus = ScreenStatus.error(err.toString());
    }
    notifyListeners();
  }
}
