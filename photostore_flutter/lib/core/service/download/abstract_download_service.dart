import 'download_service_stub.dart'
    if (dart.library.io) 'mobile_download_service.dart'
    if (dart.library.js) 'web_download_service.dart';

abstract class DownloadService {
  static DownloadService _instance;

  static DownloadService get instance {
    _instance ??= getDownloadService();
    return _instance;
  }

  Future<void> downloadImageFile(String url);

  dispose() {}
}
