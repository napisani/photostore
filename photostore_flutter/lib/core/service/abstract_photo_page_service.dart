import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/repository/media_repository.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/locator.dart';
import 'package:rxdart/rxdart.dart';

abstract class AbstractPhotoPageService {



  @protected
  final MediaRepository mediaRepo;
  final BehaviorSubject<
      Pagination<AgnosticMedia>> _photoPage = BehaviorSubject.seeded(
      Pagination<AgnosticMedia>());

  AbstractPhotoPageService({@required this.mediaRepo});

  Stream<Pagination<AgnosticMedia>> get currentPhotoPageAsStream =>
      _photoPage.stream;

  void dispose() {
    _photoPage.close();
  }

  void reset() async {
    _photoPage.add(Pagination<AgnosticMedia>());
  }

  Future<Pagination<AgnosticMedia>> loadPage(int pageNumber) async {
    if (_photoPage.value.page >= pageNumber || !_photoPage.value.hasMorePages) {
      print("page already loaded - yielding same state");
      _photoPage.add(_photoPage.value);
      return _photoPage.value;
    } else {
      final photos = await this.mediaRepo.getPhotosByPage(pageNumber);
      print("got photos: $photos");
      final newPhotos = Pagination.combineWith(_photoPage.value, photos);
      _photoPage.add(newPhotos);
      return newPhotos;
    }
  }
}
