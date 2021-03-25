import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/app_settings.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/app_settings_model.dart';
import 'package:photostore_flutter/ui/widget/screen_error_widget.dart';
import 'package:photostore_flutter/ui/widget/settings/settings_form_widget.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppSettingsModel(),
        child: Consumer<AppSettingsModel>(builder: (context, state, child) {
          Widget inner;
          if (state == null ||
              state.status.type == ScreenStatusType.UNINITIALIZED ||
              state.status.type == ScreenStatusType.LOADING) {
            inner = Text("Loading");
          } else if (state.status.type == ScreenStatusType.ERROR) {
            inner = Center(
                child: ScreenErrorWidget(
                    err: (state.status as ErrorScreenStatus).error,
                    onDismiss: () => state.reinit()));
          } else if (state.status.type == ScreenStatusType.SUCCESS) {
            final AppSettings appSettings = state.appSettings;
            inner = SettingsFormWidget(
                appSettings: appSettings,
                onSave: (settings) => state.save(settings));
          } else {
            inner = Center(
              child: Text('invalid state type: ${state.status.type}'),
            );
          }
          return Scaffold(appBar: AppBar(title: Text('Settings')), body: inner);
        }));
  }
}
