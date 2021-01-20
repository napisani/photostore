import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/blocs/app_settings_bloc.dart';
import 'package:photostore_flutter/models/state/app_settings_state.dart';
import 'package:photostore_flutter/serviceprovs/app_repository_provider.dart';
import 'package:photostore_flutter/services/settings_repository.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppRepositoryProvider(
        child: BlocProvider(
      create: (context) =>
          AppSettingsBloc(RepositoryProvider.of<SettingsRepository>(context)),
      child: _SettingsWidget(),
    ));
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
      if (state is AppSettingsInitial || state is AppSettingsLoading) {
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
                  subtitle: successState.appSettings?.serverIP ?? '',
                  onPressed: (BuildContext context) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Text("Enter Server Hostname/IP"),
                            ));
                  },
                ),
                SettingsTile.switchTile(
                  title: 'Use fingerprint',
                  switchValue: false,
                  onToggle: (bool value) {},
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
