import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/tab_service.dart';
import 'package:photostore_flutter/locator.dart';

mixin TabViewModelMixin {
  final TabService tabService = locator<TabService>();
  int _currentTabIdx;

  void registerTabLifeCycle() {
    tabService.getTabIndexAsStream().listen((int tabIdx) {
      if (_currentTabIdx == getTabIndex() && getTabIndex() != tabIdx) {
        onTabDeactivated();
      } else if (_currentTabIdx != getTabIndex() && getTabIndex() == tabIdx) {
        onTabActivated();
      }

      _currentTabIdx = tabIdx;
    });
  }

  int getTabIndex() {
    return tabService.items
        .indexWhere((element) => element.name == getTabName());
  }

  TabName getTabName();

  void onTabActivated() {}

  void onTabDeactivated() {}

  void disposeTabLifecycle() {}
}
