import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/blocs/app_settings_bloc.dart';
import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/app_settings.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/state/app_settings_state.dart';

abstract class MediaRepository<T extends AgnosticMedia> {
  @protected
  AppSettings settings;
  final AppSettingsBloc appSettingsBloc;
  final StreamController<AppSettings> _onSettingsChanged =
      new StreamController();

  MediaRepository({@required this.appSettingsBloc}) {
    this.appSettingsBloc.listenWithCurrent((AppSettingsState appSettingsState) {
      if (appSettingsState is AppSettingsSuccess) {
        print("${this.runtimeType} received new app settings!");
        this.settings = appSettingsState.appSettings;
        // this.mediaRepo.setAppSettings(_appSettings);
        this._onSettingsChanged.sink.add(this.settings);
      } else if (appSettingsState is AppSettingsInitial) {
        this.appSettingsBloc.loadSettings();
      }
    });
  }

  Stream<AppSettings> onAppSettingsChanged() => this._onSettingsChanged.stream;

  Future<Pagination<T>> getPhotosByPage(int page);

  // void setAppSettings(AppSettings settings) {
  //   this.settings = settings;
  // }

  void dispose(filename) {
    _onSettingsChanged.close();
  }
}
