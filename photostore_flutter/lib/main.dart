import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/service/tab_service.dart';
import 'package:photostore_flutter/ui/screen/settings_screen.dart';
import 'package:provider/provider.dart';

import 'core/viewmodel/app_model.dart';
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
      title: 'Photostore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
          create: (context) => AppModel(), child: _PhotoStoreApp()),
      // routes: {'/gallery': (context) => PhotoGalleryScreen()},
    );
  }
}

class _PhotoStoreApp extends StatefulWidget {
  @override
  __PhotoStoreAppState createState() => __PhotoStoreAppState();
}

class __PhotoStoreAppState extends State<_PhotoStoreApp> {
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => locator<TabService>().setTabIndex(0));
  }

  Widget _buildBottomNavBar(AppModel state) {
    if (state.tabItems.length >= 2) {
      return BottomNavigationBar(
        currentIndex: state.currentTabIndex,
        onTap: (int index) {
          if (!state.isNavigationLockedOut()) {
            state.updateTabIndex(index);
          }
        },
        items: [
          for (final tabItem in state.tabItems)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              label: tabItem.title,
            )
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print('inside main build');
    return Consumer<AppModel>(
        builder: (context, state, child) => Scaffold(
            appBar: AppBar(
              title: Text('Photostore'),
              leading: state.showRefinement
                  ? IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        state.pressedRefinement(context);
                      })
                  : null,
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        if (!state.isSettingsLockedOut()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen()),
                          ).then((_) {
                            print('resetting tab items');
                            state.resetTabItems();
                          });
                        }
                      },
                      child: Icon(Icons.settings),
                    )),
              ],
            ),
            body: IndexedStack(
              index: state.currentTabIndex,
              children: [
                for (final tabItem in state.tabItems) tabItem.page,
              ],
            ),
            bottomNavigationBar: _buildBottomNavBar(state)));
  }
}
