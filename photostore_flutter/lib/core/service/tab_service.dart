import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/ui/screen/photo_backup_screen.dart';
import 'package:photostore_flutter/ui/screen/photo_list_widget.dart';
import 'package:rxdart/rxdart.dart';

class TabService {
  final BehaviorSubject<int> _currentTabIndex =
      new BehaviorSubject<int>.seeded(0);

  List<TabNavigationItem> get items => [
        if (!kIsWeb)
          TabNavigationItem(
              page: PhotoListTabWidget(mediaSource: "MOBILE"),
              icon: Icon(Icons.devices),
              title: "Mobile",
              name: TabName.MOBILE),
        TabNavigationItem(
            page: PhotoListTabWidget(mediaSource: "SERVER"),
            icon: Icon(Icons.cloud),
            title: "Server",
            name: TabName.SERVER),
        if (!kIsWeb)
          TabNavigationItem(
              page: PhotoBackupScreen(),
              icon: Icon(Icons.cloud_upload),
              title: "Backup",
              name: TabName.BACKUP),
      ];

  void setTabIndex(int tabIndex) {
    _currentTabIndex.sink.add(tabIndex);
  }

  int getTabIndex() => _currentTabIndex.value;

  Stream<int> getTabIndexAsStream() => _currentTabIndex.stream;

  Stream<Iterable<TabName>> getTabNameAsStream() => _currentTabIndex.stream
      .map((idx) => idx < -1 ? null : items[idx].name)
      .pairwise();

  void dispose() {
    _currentTabIndex.close();
  }
}
