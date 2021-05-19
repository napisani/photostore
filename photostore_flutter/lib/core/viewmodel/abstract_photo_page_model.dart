import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/download_type.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo_page_event.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/service/media/abstract_photo_page_service.dart';
import 'package:photostore_flutter/core/service/tab_service.dart';
import 'package:photostore_flutter/locator.dart';
import 'package:rxdart/rxdart.dart';

import 'abstract_view_model.dart';

abstract class AbstractPhotoPageModel extends AbstractViewModel {
  Set<int> _pagesBeingLoaded = new HashSet<int>();
  Pagination<AgnosticMedia> photoPage;
  Set<int> selectedPhotos = new HashSet<int>();
  Subject<PhotoPageEvent> _eventStream = PublishSubject();

  @protected
  final AbstractPhotoPageService photoPageService;
  @protected
  final AppSettingsService appSettingsService = locator<AppSettingsService>();
  @protected
  final TabService tabService = locator<TabService>();

  AbstractPhotoPageModel({@required this.photoPageService}) : super() {
    _registerAppSettingsListener();
    _registerCurrentPhotoPageListener();
    _registerEventListener();
    this.initializeIfEmpty();
  }

  void _registerAppSettingsListener() {
    addSubscription(this
        .appSettingsService
        .appSettingsAsStream
        .skip(1) //skip first because you dont need to reset
        // unless the app settings CHANGES (not including initial value)
        .listen((event) {
      this.reset();
    }));
  }

  void _registerCurrentPhotoPageListener() {
    addSubscription(photoPageService.currentPhotoPageAsStream.listen((event) {
      processLoadedPhotoPage(event);
    }));
  }

  @protected
  void processLoadedPhotoPage(Pagination<AgnosticMedia> newPage) {
    print('currentPhotoPageAsStream.subscription page:${newPage?.page} '
        'total: ${newPage?.total} '
        'hasMorePages:${newPage?.hasMorePages} ');
    photoPage = newPage;
    notifyListeners();
  }

  void _registerEventListener() {
    _eventStream.stream
        .distinct((PhotoPageEvent previous, PhotoPageEvent next) {
          if (previous == next) {
            if (next.timeEmitted - previous.timeEmitted > 100) {
              return false;
            }
            return true;
          }
          return false;
        })
        .debounceTime(const Duration(milliseconds: 50))
        .where((event) =>
            !(event is PhotoPageFetchEvent) ||
            !_pagesBeingLoaded.contains((event as PhotoPageFetchEvent).page))
        .listen((PhotoPageEvent event) async {
          if (!this.isScreenEnabled()) {
            status = ScreenStatus.disabled(DISABLED_SERVER_FEATURE_TEXT);
            notifyListeners();
          } else if (event is PhotoPageResetEvent) {
            status = ScreenStatus.uninitialized();
            photoPageService.reset();
          } else if (event is PhotoPageFetchEvent) {
            this._pagesBeingLoaded.add(event.page);
            status = ScreenStatus.loading(this);
            try {
              print('in loadPage process started: ${event.page}');

              await loadPageOfPhotosInternal(event.page);
              status = ScreenStatus.success();
            } catch (err, s) {
              status = ScreenStatus.error(err.toString());
              print(
                  "AbstractPhotoPageModel:_registerEventListener failed to load loadPage: $err, $s");
              notifyListeners();
            } finally {
              this._pagesBeingLoaded.remove(event.page);
            }
          }
        });
  }

  @protected
  Future<Pagination<AgnosticMedia>> loadPageOfPhotosInternal(
      int pageNumber) async {
    print('inside loadPageOfPhotosInternal ${this.runtimeType}');
    return await photoPageService.loadPage(pageNumber);
  }

  void reset() {
    this.selectedPhotos = new HashSet<int>();
    if (this.isScreenEnabled()) {
      this._eventStream.add(PhotoPageResetEvent());
      Future.delayed(Duration(milliseconds: 120), () => loadPage(1));
    } else {
      status = ScreenStatus.disabled(DISABLED_SERVER_FEATURE_TEXT);
      notifyListeners();
    }
  }

  @protected
  bool isScreenEnabled() => this.appSettingsService.currentAppSettings != null;

  @protected
  void initializeIfEmpty() {
    if (!this.photoPageService.hasPhotosLoaded) {
      reset();
    }
  }

  bool canMultiSelect() => false;

  bool canDelete() => false;

  bool canDownload() => false;

  Future<void> handleMultiDownload(DownloadType type) async {}

  Future<void> handleMultiDelete() async {}

  void loadPage(int pageNumber) {
    print('in loadPage: $pageNumber');
    _eventStream.add(PhotoPageFetchEvent(pageNumber));
  }

  void handleMultiPhotoSelect(int index) {
    if (canMultiSelect()) {
      if (this.selectedPhotos.contains(index)) {
        this.selectedPhotos.remove(index);
      } else {
        this.selectedPhotos.add(index);
      }
      notifyListeners();
    }
  }

  void handleUnselectAll() {
    this.selectedPhotos.clear();
    notifyListeners();
  }

  @protected
  List<AgnosticMedia> getSelectedPhotos() => this
      .selectedPhotos
      .map((idx) {
        if (idx > -1 && idx < photoPage.items.length) {
          return photoPage.items[idx];
        }
        return null;
      })
      .where((photo) => photo != null)
      .toList();

  void dispose() {
    super.dispose();
    _eventStream.close();
    // photoPageService.reset();
  }
}
