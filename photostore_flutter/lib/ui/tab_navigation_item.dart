import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/ui/screen/home_screen.dart';
import 'package:photostore_flutter/ui/screen/photo_backup_screen.dart';
import 'package:photostore_flutter/ui/screen/photo_list_widget.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        // TabNavigationItem(
        //   page: HomeScreen(),
        //   icon: Icon(Icons.home),
        //   title: "mobile",
        // ),
        TabNavigationItem(
          page: PhotoListTabWidget(mediaSource: "MOBILE"),
          icon: Icon(Icons.devices),
          title: "mobile",
        ),
        TabNavigationItem(
          page: PhotoListTabWidget(mediaSource: "SERVER"),
          icon: Icon(Icons.cloud),
          title: "server",
        ),
        TabNavigationItem(
          page: PhotoBackupScreen(),
          icon: Icon(Icons.cloud_upload),
          title: "Backup",
        ),
      ];
}