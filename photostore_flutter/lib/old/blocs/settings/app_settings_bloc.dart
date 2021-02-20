// import 'dart:async';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:photostore_flutter/models/app_settings.dart';
// import 'package:photostore_flutter/blocs/settings/app_settings_state.dart';
// import 'package:photostore_flutter/services/settings_repository.dart';
//
// import '../behavior_subject_bloc_mixin.dart';
//
// class AppSettingsBloc extends Cubit<AppSettingsState> {
//   final SettingsRepository _settingsRepository;
//
//   AppSettingsBloc(this._settingsRepository) : super(AppSettingsInitial());
//
//   Future<AppSettings> loadSettings() async {
//     print("in loadSettings");
//     // emit(AppSettingsLoading());
//     try {
//       final AppSettings settings = await this._settingsRepository.getSettings();
//       emit(AppSettingsSuccess(appSettings: settings));
//       return settings;
//     } catch (ex) {
//       print('loadSettings hit error: $ex ');
//       emit(AppSettingsFailed(error: ex.toString()));
//       return null;
//     }
//   }
//
//
//
//   saveSettings(AppSettings settings) async {
//     print("in saveSettings");
//     // emit(AppSettingsLoading());
//     try {
//       final AppSettings settingsSaved =
//           await this._settingsRepository.saveSettings(settings);
//       emit(AppSettingsSuccess(appSettings: settingsSaved));
//     } catch (ex) {
//       print('saveSettings hit error: $ex ');
//       emit(AppSettingsFailed(error: ex.toString()));
//     }
//   }
//
//   Future<AppSettings> getCurrentSettings() async {
//     if (state is AppSettingsSuccess) {
//       return (state as AppSettingsSuccess).appSettings;
//     }
//     return this.loadSettings();
//   }
//
//   StreamSubscription<AppSettingsState> listenWithCurrent(
//       void Function(AppSettingsState state) onData,
//       {Function onError,
//       void Function() onDone,
//       bool cancelOnError}) {
//     onData(this.state);
//     return super.listen(onData,
//         onError: onError, onDone: onDone, cancelOnError: cancelOnError);
//   }
// }
