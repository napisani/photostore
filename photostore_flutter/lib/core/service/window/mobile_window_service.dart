import 'abstract_window_service.dart';

class MobileWindowService extends WindowService {
  @override
  int getDefaultAPIPort() {
    return 8000;
  }

  @override
  String getDefaultAPIServerIP() {
    return "";
  }

  @override
  bool isDefaultProtocolHTTPS() {
    return false;
  }
}

WindowService getWindowService() => MobileWindowService();
