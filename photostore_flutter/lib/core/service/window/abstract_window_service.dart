import 'window_service_stub.dart'
    if (dart.library.io) 'mobile_window_service.dart'
    if (dart.library.js) 'web_window_service.dart';

abstract class WindowService {
  static WindowService _instance;

  static WindowService get instance {
    _instance ??= getWindowService();
    return _instance;
  }

  String getDefaultAPIServerIP();

  int getDefaultAPIPort();

  bool isDefaultProtocolHTTPS();

  dispose() {}
}
