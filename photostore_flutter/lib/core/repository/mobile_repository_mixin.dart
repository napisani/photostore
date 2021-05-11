import 'package:photo_manager/photo_manager.dart';

mixin MobileRepositoryMixin {
  Future<bool> requestPermission({openSettings = true}) async {
    bool result = await PhotoManager.requestPermission();
    if (!result && openSettings) {
      PhotoManager.openSetting();
    }
    return result;
  }
}
