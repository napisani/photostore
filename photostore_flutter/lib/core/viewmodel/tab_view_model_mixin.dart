import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/refinement_button_sevice.dart';
import 'package:photostore_flutter/core/service/tab_service.dart';
import 'package:photostore_flutter/locator.dart';

mixin TabViewModelMixin {
  final TabService tabService = locator<TabService>();
  final RefinementButtonService refinementButtonService =
      locator<RefinementButtonService>();

  void registerTabLifeCycle() {
    this
        .tabService
        .getTabNameAsStream()
        .listen((Iterable<TabName> currentAndLastTab) {
      if (currentAndLastTab.toList()[0] == getTabName() &&
          currentAndLastTab.toList()[1] != getTabName()) {
        onTabDeactivated();
      } else if (currentAndLastTab.toList()[1] == getTabName()) {
        onTabActivated();
      }
    });
  }

  int getTabIndex() {
    return tabService.items
        .indexWhere((element) => element.name == getTabName());
  }

  TabName getTabName();

  void onTabActivated() {
    this.refinementButtonService.disableRefinement();
  }

  void onTabDeactivated() {}

  void disposeTabLifecycle() {}
}
