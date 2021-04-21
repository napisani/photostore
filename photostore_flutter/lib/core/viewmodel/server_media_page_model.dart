import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/media/server_media_service.dart';
import 'package:photostore_flutter/core/viewmodel/tab_view_model_mixin.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_model.dart';

class ServerMediaPageModel extends AbstractPhotoPageModel
    with TabViewModelMixin {
  ServerMediaPageModel()
      : super(photoPageService: locator<ServerMediaService>());

  @override
  TabName getTabName() => TabName.SERVER;
}
