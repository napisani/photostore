import 'package:photo_manager/photo_manager.dart';

mixin MobileRepositoryMixin {
  static bool _permissionGranted = false;
  static bool _permissionRequested = false;

  Future<bool> requestPermission({openSettings = true}) async {
    if (!_permissionGranted && !_permissionRequested) {
      _permissionRequested = true;
      bool result = await PhotoManager.requestPermission();
      _permissionGranted = result;
      if (!result && openSettings) {
        PhotoManager.openSetting();
      }
    }
    return _permissionGranted;
  }

  Future<void> ensurePermissionGranted({openSettings = true}) async {
    bool allowed = await requestPermission(openSettings: openSettings);
    if (!allowed) {
      throw Exception(
          "Permission to access photos must be granted in order to use Photostore");
    }
  }
}
