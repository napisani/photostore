import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/viewmodel/abstract_photo_page_model.dart';
import 'package:photostore_flutter/core/viewmodel/mobile_media_page_model.dart';
import 'package:photostore_flutter/core/viewmodel/server_media_page_model.dart';
import 'package:provider/provider.dart';

abstract class PhotoPageNotifierMixin {
  String getMediaSource();

  Consumer<AbstractPhotoPageModel> getBlockBuilder({Function builder}) =>
      getMediaSource() == 'MOBILE'
          ? Consumer<MobileMediaPageModel>(builder: builder)
          : Consumer<ServerMediaPageModel>(builder: builder);

  AbstractPhotoPageModel getPhotoPageViewModel(BuildContext context) =>
      (getMediaSource() == 'MOBILE'
          ? Provider.of<MobileMediaPageModel>(context, listen: false)
          : Provider.of<ServerMediaPageModel>(context, listen: false));
}
