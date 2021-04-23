import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/media/server_media_service.dart';
import 'package:photostore_flutter/core/service/refinement_button_sevice.dart';
import 'package:photostore_flutter/core/viewmodel/tab_view_model_mixin.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_model.dart';

class ServerMediaPageModel extends AbstractPhotoPageModel
    with TabViewModelMixin {
  RefinementButtonService _refinementButtonService =
      locator<RefinementButtonService>();

  ServerMediaPageModel()
      : super(photoPageService: locator<ServerMediaService>()) {
    registerTabLifeCycle();
  }

  @override
  TabName getTabName() => TabName.SERVER;

  @override
  bool isScreenEnabled() =>
      this.appSettingsService.areServerSettingsConfigured();

  @override
  void onTabActivated() {
    super.onTabActivated();
    print('activated server');
    _refinementButtonService.setRefinementOnPressedFunction(() {
      print('refinement pressed');
    });
  }
}
