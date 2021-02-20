import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/core/viewmodel/app_settings_model.dart';
import 'package:photostore_flutter/ui/widget/settings/settings_hostname_input_widget.dart';
import 'package:photostore_flutter/ui/widget/settings/settings_port_input_widget.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppSettingsModel(),
        child: Consumer<AppSettingsModel>(builder: (context, state, child) {
          Widget inner;
          if (state == null || state.loading || !state.initialized) {
            inner = Text("Loading");
          } else if (state.error != null) {
            inner = Text(state.error);
          } else {
            final AppSettings appSettings = state.appSettings;
            inner = SettingsList(
              sections: [
                SettingsSection(
                  title: 'Server Settings',
                  tiles: [
                    SettingsTile(
                      title: 'Hostname/IP',
                      subtitle: appSettings.serverIP ?? '',
                      onPressed: (BuildContext context) {
                        showDialog(
                            context: context,
                            builder: (context) => SettingsHostnameInputWidget(
                                serverIP: appSettings.serverIP,
                                savePressed: (newIPHostname) {
                                  final AppSettings newAppSettings = appSettings
                                      .cloneWith(serverIP: newIPHostname);
                                  state.save(newAppSettings);
                                }));
                      },
                    ),
                    SettingsTile(
                      title: 'Port Number',
                      subtitle: "${appSettings.serverPort ?? 5000}",
                      onPressed: (BuildContext context) {
                        showDialog(
                            context: context,
                            builder: (context) => SettingsPortInputWidget(
                                port: appSettings.serverPort,
                                savePressed: (newPort) {
                                  final AppSettings newAppSettings = appSettings
                                      .cloneWith(serverPort: newPort);
                                  state.save(newAppSettings);
                                }));
                      },
                    ),
                    SettingsTile.switchTile(
                      title: 'Use https',
                      switchValue: appSettings.https,
                      onToggle: (bool newHttps) {
                        final AppSettings newAppSettings =
                            appSettings.cloneWith(https: newHttps);
                        state.save(newAppSettings);
                      },
                    ),
                  ],
                ),
              ],
            );
          }

          return Scaffold(appBar: AppBar(title: Text('Settings')), body: inner);
        }));
  }
}
