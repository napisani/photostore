import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/device_management_model.dart';
import 'package:photostore_flutter/ui/widget/alert_message.dart';
import 'package:photostore_flutter/ui/widget/loading_widget.dart';
import 'package:photostore_flutter/ui/widget/screen_error_widget.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class DeviceManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DeviceManagementModel(),
        child: _DeviceManagementScreen());
  }
}

class _DeviceManagementScreen extends StatelessWidget {
  showAlertDialog(
    String deviceId,
    BuildContext context,
    Function onContinue,
  ) {
    // set up the buttons
    LinkedHashMap<String, Function> actions = LinkedHashMap();
    actions["Cancel"] = () => null;
    actions["Continue"] = onContinue;

    AlertMessage alert = AlertMessage(
        actions: actions,
        header: "Are you sure?",
        message:
            "Would you like to continue to delete all photos on the server associated with this device? \n\n$deviceId");
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceManagementModel>(builder: (context, state, child) {
      Widget inner;
      if (state == null ||
          state.status.type == ScreenStatusType.UNINITIALIZED) {
      } else if (state.status is LoadingScreenStatus) {
        inner = Center(
            child: LoadingWidget(
          animationController:
              (state.status as LoadingScreenStatus).loadingAnimationController,
        ));
      } else if (state.status.type == ScreenStatusType.ERROR) {
        inner = Center(
            child: ScreenErrorWidget(
                err: (state.status as ErrorScreenStatus).error,
                onDismiss: () => state.reinit()));
      } else if (state.status.type == ScreenStatusType.SUCCESS) {
        if (state.devices.isNotEmpty) {
          inner = SettingsList(sections: [
            SettingsSection(
                title: 'Devices',
                tiles: state.devices
                    .map((MediaDevice device) => SettingsTile(
                          title: device.deviceId,
                          subtitle: 'Photo count: ${device.count}',
                          onPressed: (BuildContext context) {
                            showAlertDialog(device.deviceId, context, () {
                              state.deletePhotos(device.deviceId);
                            });
                          },
                        ))
                    .toList())
          ]);
        } else {
          inner = Center(child: Text('No devices found on the server.'));
        }
      } else {
        inner = Center(
          child: Text('invalid state type: ${state.status.type}'),
        );
      }
      return Scaffold(appBar: AppBar(title: Text('Devices')), body: inner);
    });
  }
}
