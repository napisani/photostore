import 'package:flutter/cupertino.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;
  final TabName name;

  TabNavigationItem({
    @required this.name,
    @required this.page,
    @required this.title,
    @required this.icon,
  });
}

enum TabName {
  MOBILE,
  SERVER,
  BACKUP,
}
