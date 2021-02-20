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
  final AppSettingsService appSettingsService = locator<AppSettingsService>();
  final StreamController<AppSettings> _onSettingsChanged =
      new StreamController();

  MediaRepository() {
    this.appSettingsService.appSettingsAsStream.listen((event) {
      this.settings = event;
    });
    // this.appSettingsBloc.listenWithCurrent((AppSettingsState appSettingsState) {
    //   if (appSettingsState is AppSettingsSuccess) {
    //     print("${this.runtimeType} received new app settings!");
    //     this.settings = appSettingsState.appSettings;
    //     // this.mediaRepo.setAppSettings(_appSettings);
    //     this._onSettingsChanged.sink.add(this.settings);
    //   } else if (appSettingsState is AppSettingsInitial) {
    //     this.appSettingsBloc.loadSettings();
    //   }
    // });
  }

  Stream<AppSettings> onAppSettingsChanged() => this._onSettingsChanged.stream;

  Future<Pagination<T>> getPhotosByPage(int page);

  void dispose() {
    _onSettingsChanged.close();
  }
}
