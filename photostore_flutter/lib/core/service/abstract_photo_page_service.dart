import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/repository/media_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class AbstractPhotoPageService {
  @protected
  final MediaRepository mediaRepo;
  final BehaviorSubject<Pagination<AgnosticMedia>> _photoPage =
      BehaviorSubject.seeded(Pagination<AgnosticMedia>());

  //
  // final BehaviorSubject<Pagination<AgnosticMedia>> _photoPageFake =
  //     BehaviorSubject.seeded(Pagination<AgnosticMedia>());

  AbstractPhotoPageService({@required this.mediaRepo});

  Stream<Pagination<AgnosticMedia>> get currentPhotoPageAsStream =>
      _photoPage.stream;

  void dispose() {
    _photoPage.close();
  }

  void reset() async {
    print('inside AbstractPhotoPageService.reset()');
    _photoPage.add(Pagination<AgnosticMedia>());
  }

  bool get hasPhotosLoaded =>
      this._photoPage?.value?.items != null &&
      this._photoPage.value.items.length > 0;

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

  Future<int> getPhotoCount() async {
    return mediaRepo.getPhotoCount();
  }
}
