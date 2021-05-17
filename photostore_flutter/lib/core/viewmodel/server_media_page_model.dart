import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/download_type.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/core/model/tab_navigation_item.dart';
import 'package:photostore_flutter/core/service/download/abstract_download_service.dart';
import 'package:photostore_flutter/core/service/media/server_media_service.dart';
import 'package:photostore_flutter/core/service/refinement_button_sevice.dart';
import 'package:photostore_flutter/core/service/server_refinement_service.dart';
import 'package:photostore_flutter/core/viewmodel/tab_view_model_mixin.dart';
import 'package:photostore_flutter/locator.dart';
import 'package:photostore_flutter/ui/screen/server_refinement_screen.dart';

import 'abstract_photo_page_model.dart';

class ServerMediaPageModel extends AbstractPhotoPageModel
    with TabViewModelMixin {
  final RefinementButtonService _refinementButtonService =
      locator<RefinementButtonService>();
  final ServerRefinementService _serverRefinementService =
      locator<ServerRefinementService>();

  final DownloadService _downloadService = locator<DownloadService>();

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
    initializeIfEmpty();

    _refinementButtonService.setRefinementOnPressedFunction((context) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServerRefinementScreen(),
          )).then((_) {
        print('closed ServerRefinementScreen');
        this.reset();
      });
    });
  }

  @override
  Future<Pagination<AgnosticMedia>> loadPageOfPhotosInternal(
      int pageNumber) async {
    Map<String, String> filters = {};
    if (!_serverRefinementService.getDeviceFilter().isAll) {
      filters[DEVICE_ID_FILTER] =
          _serverRefinementService.getDeviceFilter().deviceId;
    }
    if (_serverRefinementService.getDateFilter() != null) {
      filters[MODIFIED_DATE_FILTER] =
          _serverRefinementService.getDateFilter().toString();
    }

    if (!_serverRefinementService.getAlbumFilter().isAll) {
      filters[ALBUM_FILTER] = _serverRefinementService.getAlbumFilter().name;
    }

    print(
        'inside [ServerMediaPageModel][loadPageOfPhotosInternal] filters: $filters');

    return await photoPageService.loadPage(pageNumber, filters: filters);
  }

  bool canMultiSelect() => true;

  bool canDelete() => true;

  bool canDownload() => true;

  Future<void> handleMultiDownload(DownloadType type) async {
    final List<AgnosticMedia> photos = getSelectedPhotos();
    final ServerMediaService service =
        (this.photoPageService as ServerMediaService);
    for (Photo photo in photos) {
      String url = '';
      if (type == DownloadType.THUMB) {
        url = service.getThumbnailURL(photo.id);
      } else if (type == DownloadType.FULL_PNG) {
        url = service.getFullsizePNGURL(photo.id);
      } else {
        url = service.getOriginalFileURL(photo.id);
      }
      await this._downloadService.downloadImageFile(url);
    }
  }

  Future<void> handleMultiDelete() async {
    final List<AgnosticMedia> photos = getSelectedPhotos();
    final ServerMediaService service =
        (this.photoPageService as ServerMediaService);
    for (Photo photo in photos) {
      await service.deletePhotosByID(id: photo.id);
    }
    this.reset();
  }
}
