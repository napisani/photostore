import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/media/mobile_media_service.dart';
import 'package:photostore_flutter/core/viewmodel/tab_view_model_mixin.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_model.dart';

class MobileMediaPageModel extends AbstractPhotoPageModel
    with TabViewModelMixin {
  MobileMediaPageModel()
      : super(photoPageService: locator<MobileMediaService>()) {
    registerTabLifeCycle();
  }

  @override
  TabName getTabName() => TabName.MOBILE;

  @override
  void onTabActivated() {
    super.onTabActivated();
    print('activated mobile');
    initializeIfEmpty();

  }
}
