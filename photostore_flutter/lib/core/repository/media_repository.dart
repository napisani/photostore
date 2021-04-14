import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/locator.dart';

abstract class MediaRepository<T extends AgnosticMedia> {
  @protected
  AppSettings settings;

  @protected
  int itemsPerPage = 10;

  final AppSettingsService appSettingsService = locator<AppSettingsService>();
  final StreamController<AppSettings> _onSettingsChanged =
      new StreamController();

  MediaRepository() {
    this.appSettingsService.appSettingsAsStream.listen((event) {
      this.settings = event;
      this.itemsPerPage = event.itemsPerPage;
    });
  }

  Stream<AppSettings> onAppSettingsChanged() => this._onSettingsChanged.stream;

  Future<Pagination<T>> getPhotosByPage(int page);

  Future<int> getPhotoCount();

  void dispose() {
    _onSettingsChanged.close();
  }
}
