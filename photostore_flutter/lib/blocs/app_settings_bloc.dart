import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/models/app_settings.dart';
import 'package:photostore_flutter/models/state/app_settings_state.dart';
import 'package:photostore_flutter/services/settings_repository.dart';

class AppSettingsBloc extends Cubit<AppSettingsState> {
  final SettingsRepository _settingsRepository;

  AppSettingsBloc(this._settingsRepository) : super(AppSettingsInitial());

  loadSettings() async {
    emit(AppSettingsLoading());
    try {
      final AppSettings settings = await this._settingsRepository.getSettings();
      emit(AppSettingsSuccess(appSettings: settings));
    } catch (ex) {
      print('loadSettings hit error: $ex ');
      emit(AppSettingsFailed(error: ex.toString()));
    }
  }

  saveSettings(AppSettings settings) async {
    emit(AppSettingsLoading());
    try {
      final AppSettings settingsSaved =
          await this._settingsRepository.saveSettings(settings);
      emit(AppSettingsSuccess(appSettings: settingsSaved));
    } catch (ex) {
      print('saveSettings hit error: $ex ');
      emit(AppSettingsFailed(error: ex.toString()));
    }
  }
}
