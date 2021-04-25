import 'package:photostore_flutter/core/model/lockout_type.dart';
import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/lockout_service.dart';
import 'package:photostore_flutter/core/service/refinement_button_sevice.dart';
import 'package:photostore_flutter/core/service/tab_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_view_model.dart';

class AppModel extends AbstractViewModel {
  TabService _tabService = locator<TabService>();
  RefinementButtonService _refinementButtonService =
      locator<RefinementButtonService>();

  bool showRefinement = false;

  bool isSettingsLockedOut() =>
      locator<LockoutService>().isDisabled(LockoutType.SETTINGS);

  bool isNavigationLockedOut() =>
      locator<LockoutService>().isDisabled(LockoutType.NAVIGATION);

  List<TabNavigationItem> tabItems = [];

  AppModel() {
    resetTabItems();
    _registerTabIndexListener();
    _registerRefinementButtonListener();
  }

  void _registerTabIndexListener() {
    _tabService.getTabIndexAsStream().listen((event) {
      notifyListeners();
    });
  }

  void _registerRefinementButtonListener() {
    _refinementButtonService
        .shouldShowRefinementAsStream()
        .listen((shouldShowBtn) {
      this.showRefinement = shouldShowBtn;
      notifyListeners();
    });
  }

  Future<void> resetTabItems() async {
    this.tabItems = [..._tabService.items];
    updateTabIndex(0);
    notifyListeners();
  }

  void pressedRefinement(context) {
    this._refinementButtonService.pressedRefinement(context);
  }

  void updateTabIndex(int newIdx) {
    this._tabService.setTabIndex(newIdx);
  }

  get currentTabIndex => _tabService.getTabIndex();
}
