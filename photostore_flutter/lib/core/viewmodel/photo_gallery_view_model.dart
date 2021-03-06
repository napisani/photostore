import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/download_type.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/download/abstract_download_service.dart';
import 'package:photostore_flutter/core/service/media/mobile_media_service.dart';
import 'package:photostore_flutter/core/service/media/server_media_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'abstract_photo_page_model.dart';

class PhotoGalleryViewModel extends AbstractPhotoPageModel {
  final DownloadService _downloadService = locator<DownloadService>();
  final ServerMediaService _serverMediaService = locator<ServerMediaService>();

  final pageController;
  int photoIndex;
  final bool isAPIPhotos;

  PhotoGalleryViewModel(String mediaSource, this.isAPIPhotos,
      {this.photoIndex = 0})
      : pageController = PageController(initialPage: photoIndex),
        super(
          photoPageService: mediaSource == "MOBILE"
              ? locator<MobileMediaService>()
              : locator<ServerMediaService>());

  int nextPageNumber() {
    return (photoPage?.page ?? 0) + 1;
  }

  void loadNextPage() {
    loadPage(nextPageNumber());
  }

  void handlePhotoPageSwipe(int newPage, BuildContext context) {
    photoIndex = newPage;
    if (photoIndex >= photoPage.items.length - 1) {
      loadNextPage();
    }
    doPrecache(context);
    notifyListeners();
  }

  @override
  void initializeIfEmpty() {
    super.initializeIfEmpty();
    if (this.photoPageService.hasPhotosLoaded) {
      this.screenStatus = ScreenStatus.success();
      this.notifyListeners();
    }
  }

  @override
  TabName getTabName() => TabName.SERVER;

  Future<void> download(DownloadType type) async {
    if (this.isAPIPhotos && getCurrentPhoto() != null) {
      String url = '';
      if (type == DownloadType.THUMB) {
        url = this._serverMediaService.getThumbnailURL(getCurrentPhoto().id);
      } else if (type == DownloadType.FULL_PNG) {
        url = this._serverMediaService.getFullsizePNGURL(getCurrentPhoto().id);
      } else {
        url = this._serverMediaService.getOriginalFileURL(getCurrentPhoto().id);
      }
      await this._downloadService.downloadImageFile(url);
    }
  }

  AgnosticMedia _getPhotoAtIndexSafe(int idx) {
    if (photoPage != null &&
        photoPage.items != null &&
        idx < photoPage.items.length &&
        idx > -1) {
      return photoPage.items[idx];
    }
    return null;
  }

  // @override
  // void processLoadedPhotoPage(Pagination<AgnosticMedia> newPage) {
  //   super.processLoadedPhotoPage(newPage);
  // }

  void doPrecache(BuildContext context) async {
    [0, 1,  2, -2, 3, -3].map((offset) => _getPhotoAtIndexSafe(photoIndex + offset))
        .where((element) => element != null)
        .forEach((element) {
      print('doing precache: $element');
      precacheImage(element.thumbnailOfDeviceSizeProvider, context);
    });
  }

  AgnosticMedia getCurrentPhoto() => _getPhotoAtIndexSafe(photoIndex);

  AgnosticMedia getPreviousPhoto() => _getPhotoAtIndexSafe(photoIndex - 1);

  AgnosticMedia getNextPhoto() => _getPhotoAtIndexSafe(photoIndex + 1);

  Future<void> handleDeleteSinglePhoto() async {
    if (this.isAPIPhotos && getCurrentPhoto() != null) {
      await this._serverMediaService.deletePhotosByID(id: getCurrentPhoto().id);
    }
  }

  void dispose() {
    super.dispose();
  }
}
