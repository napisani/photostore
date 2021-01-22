import 'package:flutter/material.dart';
import 'package:photostore_flutter/screens/settings_screen.dart';
import 'package:photostore_flutter/serviceprovs/app_repository_provider.dart';
import 'package:photostore_flutter/tab_item.dart';
import 'package:photostore_flutter/tab_navigator.dart';

import 'bottom_navigation.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppRepositoryProvider(child: _PhotoStoreApp()),
    );
    ;
  }
}

class _PhotoStoreApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhotoStoreAppState();
}

class _PhotoStoreAppState extends State<_PhotoStoreApp> {
  var _currentTab = TabItem.home;
  var _currentWidget;

  _PhotoStoreAppState() {
    this._currentWidget = _buildAdHocNavigator(TabItem.home);
  }

  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.mobile: GlobalKey<NavigatorState>(),
    TabItem.server: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    print("main:_PhotoStoreApp:_selectTab tabItem: $tabItem");
    if (tabItem == _currentTab) {
      // pop to first route
      // _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
        this._currentWidget = _buildAdHocNavigator(_currentTab);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.home) {
            // select 'main' tab
            _selectTab(TabItem.home);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Photos'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                  child: Icon(Icons.settings),
                )),
          ],
        ),
        body: _currentWidget,
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  /*
  Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.home),
          _buildOffstageNavigator(TabItem.mobile),
          _buildOffstageNavigator(TabItem.server),
        ]),
   */

  Widget _buildAdHocNavigator(TabItem tabItem) {
    return TabNavigator(
      navigatorKey: _navigatorKeys[tabItem],
      tabItem: tabItem,
    );
  }

  // Widget _buildOffstageNavigator(TabItem tabItem) {
  //   return Offstage(
  //     offstage: _currentTab != tabItem,
  //     child: TabNavigator(
  //       navigatorKey: _navigatorKeys[tabItem],
  //       tabItem: tabItem,
  //     ),
  //   );
  // }
}
