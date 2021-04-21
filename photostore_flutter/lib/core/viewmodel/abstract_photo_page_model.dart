import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo_page_event.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/service/media/abstract_photo_page_service.dart';
import 'package:photostore_flutter/locator.dart';
import 'package:rxdart/rxdart.dart';

import 'abstract_view_model.dart';

abstract class AbstractPhotoPageModel extends AbstractViewModel {
  Pagination<AgnosticMedia> photoPage;
  Subject<PhotoPageEvent> _eventStream = PublishSubject();
  @protected
  final AbstractPhotoPageService photoPageService;
  final AppSettingsService _appSettingsService = locator<AppSettingsService>();

  AbstractPhotoPageModel({@required this.photoPageService}) : super() {
    _registerAppSettingsListener();
    _registerCurrentPhotoPageListener();
    _registerEventListener();
    this.initialize();
  }

  void _registerAppSettingsListener() {
    addSubscription(
        this._appSettingsService.appSettingsAsStream.listen((event) {
      // this.reset();
      this.initialize();
    }));
  }

  void _registerCurrentPhotoPageListener() {
    addSubscription(photoPageService.currentPhotoPageAsStream.listen((event) {
      print('currentPhotoPageAsStream.subscription page:${event?.page} '
          'total: ${event?.total} '
          'hasMorePages:${event?.hasMorePages} ');
      photoPage = event;
      notifyListeners();
    }));
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
        .listen((PhotoPageEvent event) async {
          if (event is PhotoPageResetEvent) {
            status = ScreenStatus.uninitialized();
            photoPageService.reset();
          } else if (event is PhotoPageFetchEvent) {
            status = ScreenStatus.loading(this);
            try {
              print('in loadPage process started: ${event.page}');

              await photoPageService.loadPage(event.page);
              status = ScreenStatus.success();
            } catch (err, s) {
              status = ScreenStatus.error(err.toString());
              print(
                  "AbstractPhotoPageModel:_registerEventListener failed to load loadPage: $err, $s");
              notifyListeners();
            }
          }
        });
  }

  void reset() {
    if (this._appSettingsService.currentAppSettings != null) {
      this._eventStream.add(PhotoPageResetEvent());
      Future.delayed(Duration(milliseconds: 120), () => loadPage(1));
    }
  }

  void initialize() {
    if (!this.photoPageService.hasPhotosLoaded) {
      this.reset();
    }
  }

  void loadPage(int pageNumber) {
    print('in loadPage: $pageNumber');
    _eventStream.add(PhotoPageFetchEvent(pageNumber));
  }

  void dispose() {
    super.dispose();
    _eventStream.close();
    // photoPageService.reset();
  }
}
