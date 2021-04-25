import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/ui/screen/device_management_screen.dart';
import 'package:photostore_flutter/ui/widget/settings/text_setting_input_widget.dart';
import 'package:settings_ui/settings_ui.dart';

import 'int_setting_input_widget.dart';

typedef SaveSettingsFunction = void Function(AppSettings settings);

class SettingsFormWidget extends StatelessWidget {
  final AppSettings appSettings;
  final SaveSettingsFunction onSave;

  SettingsFormWidget({this.appSettings, this.onSave});

  String _elipsify(String str, {int size = 10}) {
    if (str == null || str.length <= size) {
      return str;
    }
    return str.substring(0, size) + '...';
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Server Settings',
          tiles: [
            SettingsTile(
              title: 'Hostname/IP',
              subtitle: _elipsify(appSettings.serverIP ?? ''),
              onPressed: (BuildContext context) {
                showDialog(
                    context: context,
                    builder: (context) => TextSettingInputWidget(
                        prompt: "Enter Server Hostname/IP",
                        textValue: appSettings.serverIP,
                        savePressed: (newIPHostname) {
                          final AppSettings newAppSettings =
                              appSettings.cloneWith(serverIP: newIPHostname);
                          _save(newAppSettings);
                        }));
              },
            ),
            SettingsTile(
              title: 'Port Number',
              subtitle: _elipsify("${appSettings.serverPort ?? 5000}"),
              onPressed: (BuildContext context) {
                showDialog(
                    context: context,
                    builder: (context) => IntegerSettingInputWidget(
                        prompt: "Enter Port Number",
                        intValue: appSettings.serverPort,
                        savePressed: (newPort) {
                          final AppSettings newAppSettings =
                              appSettings.cloneWith(serverPort: newPort);
                          _save(newAppSettings);
                        }));
              },
            ),
            SettingsTile.switchTile(
              title: 'Use https',
              switchValue: appSettings.https ?? false,
              onToggle: (bool newHttps) {
                final AppSettings newAppSettings =
                    appSettings.cloneWith(https: newHttps);
                _save(newAppSettings);
              },
            ),
            SettingsTile(
              title: 'API Key',
              subtitle: _elipsify("${appSettings.apiKey ?? ''}"),
              onPressed: (BuildContext context) {
                showDialog(
                    context: context,
                    builder: (context) => TextSettingInputWidget(
                        prompt: "Enter API Key",
                        textValue: appSettings.apiKey ?? '',
                        savePressed: (apiKey) {
                          final AppSettings newAppSettings =
                              appSettings.cloneWith(apiKey: apiKey);
                          _save(newAppSettings);
                        }));
              },
            ),
            SettingsTile(
              title: 'Device ID',
              subtitle: _elipsify("${appSettings.deviceID ?? ''}"),
              onPressed: (BuildContext context) {
                showDialog(
                    context: context,
                    builder: (context) => TextSettingInputWidget(
                        prompt: "Enter Device ID",
                        textValue: appSettings.deviceID ?? '',
                        savePressed: (devId) {
                          final AppSettings newAppSettings =
                              appSettings.cloneWith(deviceID: devId);
                          _save(newAppSettings);
                        }));
              },
            ),
          ],
        ),
        SettingsSection(title: 'Advanced Settings', tiles: [
          SettingsTile(
            title: 'Batch Size',
            subtitle: _elipsify("${appSettings.batchSize ?? 5}"),
            onPressed: (BuildContext context) {
              showDialog(
                  context: context,
                  builder: (context) => IntegerSettingInputWidget(
                      prompt: "Enter Batch Size",
                      intValue: appSettings.batchSize,
                      savePressed: (batch) {
                        final AppSettings newAppSettings =
                            appSettings.cloneWith(batchSize: batch);
                        _save(newAppSettings);
                      }));
            },
          ),
          SettingsTile(
            title: 'Items per Page',
            subtitle: _elipsify("${appSettings.itemsPerPage ?? 10}"),
            onPressed: (BuildContext context) {
              showDialog(
                  context: context,
                  builder: (context) => IntegerSettingInputWidget(
                      prompt: "Items per Page",
                      intValue: appSettings.itemsPerPage,
                      savePressed: (batch) {
                        final AppSettings newAppSettings =
                            appSettings.cloneWith(itemsPerPage: batch);
                        _save(newAppSettings);
                      }));
            },
          ),
          SettingsTile(
            title: 'Upload Retry Attempt Count',
            subtitle: _elipsify("${appSettings.uploadRetryAttempts ?? 2}"),
            onPressed: (BuildContext context) {
              showDialog(
                  context: context,
                  builder: (context) => IntegerSettingInputWidget(
                      prompt: "Enter Upload Retry Attempt Count",
                      intValue: appSettings.uploadRetryAttempts,
                      savePressed: (cnt) {
                        final AppSettings newAppSettings =
                            appSettings.cloneWith(uploadRetryAttempts: cnt);
                        _save(newAppSettings);
                      }));
            },
          ),
          SettingsTile(
            title: 'Connect timeout (seconds)',
            subtitle: _elipsify("${appSettings.connectTimeout ?? 60}"),
            onPressed: (BuildContext context) {
              showDialog(
                  context: context,
                  builder: (context) => IntegerSettingInputWidget(
                      prompt: "Connect timeout (seconds)",
                      intValue: appSettings.connectTimeout,
                      savePressed: (cnt) {
                        final AppSettings newAppSettings =
                            appSettings.cloneWith(connectTimeout: cnt);
                        _save(newAppSettings);
                      }));
            },
          ),
          SettingsTile(
            title: 'Retrieve timeout (seconds)',
            subtitle: _elipsify("${appSettings.receiveTimeout ?? 60}"),
            onPressed: (BuildContext context) {
              showDialog(
                  context: context,
                  builder: (context) => IntegerSettingInputWidget(
                      prompt: "Retrieve timeout (seconds)",
                      intValue: appSettings.receiveTimeout,
                      savePressed: (cnt) {
                        final AppSettings newAppSettings =
                            appSettings.cloneWith(receiveTimeout: cnt);
                        _save(newAppSettings);
                      }));
            },
          ),
        ]),
        SettingsSection(title: "Devices", tiles: [
          SettingsTile(
            title: 'Manage devices...',
            onPressed: (BuildContext context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeviceManagementScreen()),
              ).then((_) {
                print('closed device management');
                // state.resetTabItems();
              });
            },
          )
        ])
      ],
    );
  }

  _save(AppSettings settings) {
    if (onSave != null) {
      onSave(settings);
    }
  }
}
