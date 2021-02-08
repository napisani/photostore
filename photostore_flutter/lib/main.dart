import 'package:flutter/material.dart';
import 'package:photostore_flutter/screens/settings_screen.dart';
import 'package:photostore_flutter/serviceprovs/app_level_provider.dart';
import 'package:photostore_flutter/tab_navigation_item.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLevelProviders(
        child: MaterialApp(
      title: 'Photo Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _PhotoStoreApp(),
      // routes: {'/gallery': (context) => PhotoGalleryScreen()},
    ));
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  ).then((_) {
                    print('resetting tab items');
                    this.setState(() {
                      tabItems = TabNavigationItem.items;
                    });
                  });
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
        onTap: (int index) => setState(() => _currentIndex = index),
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

// Widget _buildAdHocNavigator(TabItem tabItem) {
//   return TabNavigator(
//     navigatorKey: _navigatorKeys[tabItem],
//     tabItem: tabItem,
//   );
// }
//
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
