// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'abstract_window_service.dart';

class WebWindowService extends WindowService {
  @override
  String getDefaultAPIServerIP() {
    final url = html.window.location.hostname;
    print('defaulting to URL: $url');
    return url;
  }

  @override
  int getDefaultAPIPort() {
    print('defaulting to Port: ${html.window.location.port}');
    try {
      return int.parse(html.window.location.port);
    } catch (e) {
      int port = this.isDefaultProtocolHTTPS() ? 443 : 80;
      print('failed to parse Port from window location using:$port');
      return port;
    }
  }

  @override
  bool isDefaultProtocolHTTPS() {
    String href = html.window.location.href;
    List<String> protoAndUrl = href.split("//");
    bool isHttps = protoAndUrl[0].toLowerCase().startsWith("https");
    print('defaulting to https: ${isHttps}');
    return isHttps;
  }
}

WindowService getWindowService() => WebWindowService();
