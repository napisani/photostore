import 'package:flutter/material.dart';

enum TabItem { home, mobile, server }


const Map<TabItem, TabDefinition> tabs = {
  TabItem.server: TabDefinition(name: 'server', initialRoute: '/server'),
  TabItem.mobile: TabDefinition(name: 'mobile', initialRoute: '/mobile'),
  TabItem.home: TabDefinition(name: 'home', initialRoute: '/'),
};

class TabDefinition {
  final String name;
  final MaterialColor activeColor;
  final String initialRoute;

  const TabDefinition(
      {this.name, this.activeColor = Colors.blue, this.initialRoute = "/"});
}
