import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/lockout_type.dart';
import 'package:photostore_flutter/core/service/lockout_service.dart';
import 'package:photostore_flutter/ui/screen/settings_screen.dart';
import 'package:photostore_flutter/ui/tab_navigation_item.dart';

import 'locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print('inside main func');
  setupLocator();
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
      home: _PhotoStoreApp(),
      // routes: {'/gallery': (context) => PhotoGalleryScreen()},
    );
  }
}

class _PhotoStoreApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhotoStoreAppState();
}

class _PhotoStoreAppState extends State<_PhotoStoreApp> {
  int _currentIndex = 0;
  List<TabNavigationItem> tabItems;

  _PhotoStoreAppState() {
    this.tabItems = TabNavigationItem.items;
    print('calling setup');
    setupLocator();
  }

  // // This is the trick!
  // void _reset() {
  //   Navigator.pushReplacement(
  //     context,
  //     PageRouteBuilder(
  //       transitionDuration: Duration.zero,
  //       pageBuilder: (_, __, ___) => DummyWidget(),
  //     ),
  //   );
  // }

  bool _isSettingsLockedOut() =>
      locator<LockoutService>().isDisabled(LockoutType.SETTINGS);

  bool _isNavigationLockedOut() =>
      locator<LockoutService>().isDisabled(LockoutType.NAVIGATION);

  @override
  Widget build(BuildContext context) {
    print('inside main build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (!this._isSettingsLockedOut()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    ).then((_) {
                      print('resetting tab items');
                      this.setState(() {
                        tabItems = TabNavigationItem.items;
                      });
                    });
                  }
                },
                child: Icon(Icons.settings),
              )),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in this.tabItems) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          if (!_isNavigationLockedOut()) {
            setState(() => _currentIndex = index);
          }
        },
        items: [
          for (final tabItem in this.tabItems)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              label: tabItem.title,
            )
        ],
      ),
    );
  }
}
