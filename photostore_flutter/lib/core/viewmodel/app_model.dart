import 'package:photostore_flutter/core/model/lockout_type.dart';
import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/lockout_service.dart';
import 'package:photostore_flutter/core/service/tab_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_view_model.dart';

class AppModel extends AbstractViewModel {
  TabService _tabService = locator<TabService>();

  bool isSettingsLockedOut() =>
      locator<LockoutService>().isDisabled(LockoutType.SETTINGS);

  bool isNavigationLockedOut() =>
      locator<LockoutService>().isDisabled(LockoutType.NAVIGATION);

  List<TabNavigationItem> tabItems = [];

  AppModel() {
    resetTabItems();
    registerTabIndexListener();
  }

  void registerTabIndexListener() {
    _tabService.getTabIndexAsStream().listen((event) {
      notifyListeners();
    });
  }

  void resetTabItems() {
    this.tabItems = [..._tabService.items];
    notifyListeners();
  }

  void updateTabIndex(int newIdx) {
    this._tabService.setTabIndex(newIdx);
  }

  get currentTabIndex => _tabService.getTabIndex();
}
