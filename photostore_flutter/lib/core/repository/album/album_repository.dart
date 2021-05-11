import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';

import '../../../locator.dart';

abstract class AlbumRepository {
  @protected
  AppSettings settings;

  @protected
  int itemsPerPage = 10;

  final AppSettingsService appSettingsService = locator<AppSettingsService>();

  AlbumRepository() {
    this.appSettingsService.appSettingsAsStream.listen((event) {
      this.settings = event;
      this.itemsPerPage = event.itemsPerPage;
    });
  }

  Future<List<PhotoAlbum>> getAllAlbums({Map<String, String> filters});

  void dispose() {}
}
