import 'package:flutter/material.dart';
import 'package:photostore_flutter/screens/home_screen.dart';
import 'package:photostore_flutter/screens/photo_list_widget.dart';
import 'package:photostore_flutter/screens/settings_screen.dart';
import 'package:photostore_flutter/tab_item.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String server = '/server';
  static const String mobile = '/mobile';
  static const String settings = '/settings';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});

  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  void _push(BuildContext context, {int materialIndex: 500}) {
    var routeBuilders = _routeBuilders(context, materialIndex: materialIndex);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[TabNavigatorRoutes.server](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {int materialIndex: 500}) {
    return {
      TabNavigatorRoutes.root: (context) => HomeScreen(
            onPush: (materialIndex) =>
                _push(context, materialIndex: materialIndex),
          ),
      TabNavigatorRoutes.server: (context) => PhotoListTabWidget(
            mediaSource: "SERVER",
            onPush: (materialIndex) =>
                _push(context, materialIndex: materialIndex),
          ),
      TabNavigatorRoutes.mobile: (context) => PhotoListTabWidget(
            mediaSource: "MOBILE",
            onPush: (materialIndex) =>
                _push(context, materialIndex: materialIndex),
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    print('TabNavigator.build: tabItem: $tabItem  navigatorKey: $navigatorKey');
    return Navigator(
      key: navigatorKey,
      initialRoute: tabs[tabItem].initialRoute,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) {
            print("in onGenerateRoute: routeSettings: $routeSettings");
            return routeBuilders[routeSettings.name](context);
          },
        );
      },
    );
  }
}
