import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo_page_event.dart';
import 'package:photostore_flutter/core/service/abstract_photo_page_service.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/locator.dart';
import 'package:rxdart/rxdart.dart';

abstract class AbstractPhotoPageModel with ChangeNotifier {

  bool initialized = false;
  bool loading = false;
  String error;
  Pagination<AgnosticMedia> photoPage;
  Subject<PhotoPageEvent> _eventStream = PublishSubject();

  @protected
  final AbstractPhotoPageService photoPageService;
  final AppSettingsService _appSettingsService = locator<AppSettingsService>();

  AbstractPhotoPageModel({@required this.photoPageService}) {
    _registerAppSettingsListener();
    _registerCurrentPhotoPageListener();
    _registerEventListener();
  }

  void _registerAppSettingsListener() {
    this._appSettingsService.appSettingsAsStream.listen((event) {
      if (initialized) {
        initialized = false;
        photoPageService.reset();
      }
    });
  }

  void _registerCurrentPhotoPageListener() {
    photoPageService.currentPhotoPageAsStream.listen((event) {
      photoPage = event;
      notifyListeners();
    });
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
          if (event is PhotoPageFetchEvent) {
            initialized = true;
            try {
              await photoPageService.loadPage(event.page);
            } catch (err) {
              error = err.toString();
              print(err);
              notifyListeners();
            }
          } else if (event is PhotoPageResetEvent) {
            initialized = false;
            photoPageService.reset();
          }
        });
  }

  void reset() {
    this._eventStream.add(PhotoPageResetEvent());
  }

  void loadPage(int pageNumber) {
    _eventStream.add(PhotoPageFetchEvent(pageNumber));
  }

  void dispose() {
    _eventStream.close();
    photoPageService.reset();
    super.dispose();
  }
}
