import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/repository/settings_repository.dart';
import 'package:photostore_flutter/locator.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onPush;

  const HomeScreen({Key key, this.onPush}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text( 'in setup ${locator.isRegistered<SettingsRepository>()}');
  }
}
