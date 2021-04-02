import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/mobile_media_service.dart';
import 'package:photostore_flutter/core/service/server_media_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_model.dart';

class PhotoGalleryViewModel extends AbstractPhotoPageModel {
  final pageController;
  int photoIndex;

  PhotoGalleryViewModel(String mediaSource, {this.photoIndex = 0})
      : pageController = PageController(initialPage: photoIndex),
        super(
            photoPageService: mediaSource == "MOBILE"
                ? locator<MobileMediaService>()
                : locator<ServerMediaService>()) {
    this.initialize();
  }

  int nextPageNumber() {
    return (photoPage?.page ?? 0) + 1;
  }

  void loadNextPage() {
    loadPage(nextPageNumber());
  }

  void handlePhotoPageSwipe(int newPage) {
    photoIndex = newPage;
    if (photoIndex >= photoPage.items.length - 1) {
      loadNextPage();
    }
  }
  void initialize() {
    super.initialize();
    if (this.photoPageService.hasPhotosLoaded) {
      this.screenStatus = ScreenStatus.success();
      this.notifyListeners();
    }
  }

  void dispose() {
    super.dispose();
  }
}
