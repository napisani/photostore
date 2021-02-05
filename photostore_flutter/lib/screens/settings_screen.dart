import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/blocs/app_settings_bloc.dart';
import 'package:photostore_flutter/components/settings/settings_hostname_input_widget.dart';
import 'package:photostore_flutter/components/settings/settings_port_input_widget.dart';
import 'package:photostore_flutter/models/app_settings.dart';
import 'package:photostore_flutter/models/state/app_settings_state.dart';
import 'package:photostore_flutter/serviceprovs/app_repository_provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SettingsWidget();
  }
}

class _SettingsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<_SettingsWidget> {
  AppSettingsBloc _appSettingsBloc;

  @override
  void initState() {
    super.initState();
    _appSettingsBloc = BlocProvider.of<AppSettingsBloc>(context);
    _appSettingsBloc.loadSettings();

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
      Widget inner;
      if (state is AppSettingsInitial) {
        inner = Text("Loading");
      } else if (state is AppSettingsFailed) {
        inner = Text(state.error);
      } else {
        final AppSettingsSuccess successState = state as AppSettingsSuccess;
        inner = SettingsList(
          sections: [
            SettingsSection(
              title: 'Server Settings',
              tiles: [
                SettingsTile(
                  title: 'Hostname/IP',
                  subtitle: successState.appSettings.serverIP ?? '',
                  onPressed: (BuildContext context) {
                    showDialog(
                        context: context,
                        builder: (context) => SettingsHostnameInputWidget(
                            serverIP: successState.appSettings.serverIP,
                            savePressed: (newIPHostname) {
                              final AppSettings newAppSettings = successState
                                  .appSettings
                                  .cloneWith(serverIP: newIPHostname);
                              _appSettingsBloc.saveSettings(newAppSettings);
                            }));
                  },
                ),
                SettingsTile(
                  title: 'Port Number',
                  subtitle: "${successState.appSettings.serverPort ?? 5000}",
                  onPressed: (BuildContext context) {
                    showDialog(
                        context: context,
                        builder: (context) => SettingsPortInputWidget(
                            port: successState.appSettings.serverPort,
                            savePressed: (newPort) {
                              final AppSettings newAppSettings = successState
                                  .appSettings
                                  .cloneWith(serverPort: newPort);
                              _appSettingsBloc.saveSettings(newAppSettings);
                            }));
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Use https',
                  switchValue: successState.appSettings.https,
                  onToggle: (bool newHttps) {
                    final AppSettings newAppSettings =
                        successState.appSettings.cloneWith(https: newHttps);
                    _appSettingsBloc.saveSettings(newAppSettings);
                  },
                ),
              ],
            ),
          ],
        );
      }

      return Scaffold(appBar: AppBar(title: Text('Settings')), body: inner);
    });
  }
}
