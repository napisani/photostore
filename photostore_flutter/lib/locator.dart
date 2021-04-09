import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:photostore_flutter/core/repository/media_api_repository.dart';
import 'package:photostore_flutter/core/repository/media_mobile_repositoryV2.dart';
import 'package:photostore_flutter/core/service/backup_services.dart';

import 'core/repository/settings_repository.dart';
import 'core/service/app_settings_service.dart';
import 'core/service/http_service.dart';
import 'core/service/mobile_media_service.dart';
import 'core/service/server_media_service.dart';

// import 'package:http/http.dart' as http;

GetIt locator = GetIt.instance;
bool _isLoaded = false;

void setupLocator() {
  print('setupLocator');
  print('in setup ${locator.isRegistered<SettingsRepository>()}');

  if (!_isLoaded) {
    print('setupLocator - loading');
    _isLoaded = true;

    locator
        .registerLazySingleton<SettingsRepository>(() => SettingsRepository());
    locator.registerLazySingleton<AppSettingsService>(
        () => AppSettingsService(),
        dispose: (service) => service.dispose());

    locator.registerLazySingleton<ServerMediaService>(
        () => ServerMediaService(),
        dispose: (service) => service.dispose());

    // locator.registerLazySingleton<http.Client>(() => http.Client());
    locator.registerLazySingleton<HTTPService>(() => HTTPService(),
        dispose: (service) => service.dispose());
    locator.registerLazySingleton<MediaAPIRepository>(
        () => MediaAPIRepository(),
        dispose: (service) => service.dispose());

    if (!kIsWeb) {
      locator.registerLazySingleton<MobileMediaService>(
          () => MobileMediaService(),
          dispose: (service) => service.dispose());
      locator.registerLazySingleton<BackupService>(() => BackupService(),
          dispose: (service) => service.dispose());
      locator.registerLazySingleton<MediaMobileRepositoryV2>(
          () => MediaMobileRepositoryV2(),
          dispose: (service) => service.dispose());
    }
  }

  // locator.registerSingleton<SettingsRepository>(SettingsRepository());
  // locator.registerSingleton<AppSettingsService>(AppSettingsService(),
  //     dispose: (service) => service.dispose());
  // locator.registerSingleton<MobileMediaService>(MobileMediaService(),
  //     dispose: (service) => service.dispose());
  // locator.registerSingleton<ServerMediaService>(ServerMediaService(),
  //     dispose: (service) => service.dispose());
  // locator.registerLazySingleton<http.Client>(() => http.Client());
  // locator.registerLazySingleton<SettingsRepository>(() => SettingsRepository());
  // locator.registerLazySingleton<AppSettingsService>(() => AppSettingsService(),
  //     dispose: (service) => service.dispose());
  // locator.registerLazySingleton<MobileMediaService>(() => MobileMediaService(),
  //     dispose: (service) => service.dispose());
  // locator.registerLazySingleton<ServerMediaService>(() => ServerMediaService(),
  //     dispose: (service) => service.dispose());
  // locator.registerSingleton<http.Client>(http.Client());

  // locator.registerLazySingleton(() => Api());
  //
  // locator.registerLazySingleton(() => LoginModel());
  // locator.registerFactory(() => HomeModel());
  // locator.registerFactory(() => CommentsModel());
}
