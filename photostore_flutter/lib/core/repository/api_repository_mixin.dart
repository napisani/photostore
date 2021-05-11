import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/core/service/http_service.dart';

import '../../locator.dart';

mixin APIRepositoryMixin {
  @protected
  final HTTPService httpService = locator<HTTPService>();

  @protected
  String getBaseURL(AppSettings settings) {
    if (settings != null) {
      return "${settings.https ? "https" : "http"}://${settings.serverIP}:${settings.serverPort}/api/v1";
    }
    throw new Exception("Server settings are not configured");
  }

  @protected
  void checkForCorrectAuth(Response response) {
    if (response.statusCode == 403 || response.statusCode == 401) {
      throw Exception(
          "The server denied access, please check your API Key settings.");
    }
  }

  @protected
  String urlEncode(String uri) => Uri.encodeFull(uri);
}
