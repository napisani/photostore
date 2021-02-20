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
    if (_photoPage.value.page >= pageNumber) {
      print("page already loaded - yielding same state");
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
  // AbstractPhotoPageBloc({@required this.mediaRepo})
  //     : super(PhotoPageStateInitial()) {
  //   this.mediaRepo.appSettingsBloc.listen((state) {
  //     if (!(state is PhotoPageStateInitial)) {
  //       print("PhotoPageBloc adding reset event");
  //       this.add(PhotoPageResetEvent());
  //     }
  //   });
  // }
  //
  // bool _hasEndBeenReached(PhotoPageState state) =>
  //     state is PhotoPageStateSuccess && state.reachedEnd();
  //
  // @override
  // Stream<PhotoPageState> mapEventToState(PhotoPageEvent event) async* {
  //   final currentState = state.clone();
  //   print("in mapEventToState $event ${_hasEndBeenReached(currentState)}");
  //   if (event is PhotoPageFetchEvent && !_hasEndBeenReached(currentState)) {
  //     // yield PhotoPageStateLoading(photos: currentState.photos);
  //     print('working on PhotoPageFetchEvent page: ${event.page}');
  //     try {
  //       if (currentState is PhotoPageStateInitial) {
  //         final Pagination<AgnosticMedia> photoPage =
  //         (await this.mediaRepo.getPhotosByPage(event.page));
  //         print("got first photoPage: $photoPage");
  //         yield PhotoPageStateSuccess(photos: photoPage);
  //       } else if (currentState is PhotoPageStateSuccess) {
  //         if (currentState.photos.page >= event.page) {
  //           print("page already loaded - yielding same state");
  //           yield currentState;
  //         } else {
  //           final photos = await this.mediaRepo.getPhotosByPage(event.page);
  //           print("got photos: $photos");
  //
  //           yield photos.items.isEmpty
  //               ? currentState.copyWith()
  //               : currentState.copyWith(newPhotos: photos);
  //         }
  //       }
  //     } catch (err) {
  //       print("error getting Photo Page err: $err");
  //       yield PhotoPageStateFailure(errorMessage: err.toString());
  //     }
  //   } else if (event is PhotoPageResetEvent) {
  //     yield PhotoPageStateInitial();
  //   }
  // }
  //
  // @override
  // Stream<Transition<PhotoPageEvent, PhotoPageState>> transformEvents(events,
  //     transitionFn) {
  //   return events
  //       .distinct((PhotoPageEvent previous, PhotoPageEvent next) {
  //     if (previous == next) {
  //       if (next.timeEmitted - previous.timeEmitted > 100) {
  //         return false;
  //       }
  //       return true;
  //     }
  //     return false;
  //   })
  //       .debounceTime(const Duration(milliseconds: 50))
  //       .switchMap(transitionFn);
  // }
