// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:photostore_flutter/core/model/pagination.dart';
// import 'package:photostore_flutter/models/agnostic_media.dart';
// import 'package:photostore_flutter/blocs/photo_page/photo_page_event.dart';
// import 'package:photostore_flutter/models/pagination.dart';
// import 'package:photostore_flutter/blocs/photo_page/photo_page_state.dart';
// import 'package:photostore_flutter/core/model/photo_page_event.dart';
// import 'package:photostore_flutter/services/media_repository.dart';
// import 'package:rxdart/rxdart.dart';
//
// abstract class AbstractPhotoPageBloc
//     extends Bloc<PhotoPageEvent, PhotoPageState> {
//   final MediaRepository mediaRepo;
//
//   AbstractPhotoPageBloc({@required this.mediaRepo})
//       : super(PhotoPageStateInitial()) {
//     this.mediaRepo.appSettingsBloc.listen((state) {
//       if (!(state is PhotoPageStateInitial)) {
//         print("PhotoPageBloc adding reset event");
//         this.add(PhotoPageResetEvent());
//       }
//     });
//   }
//
//   bool _hasEndBeenReached(PhotoPageState state) =>
//       state is PhotoPageStateSuccess && state.reachedEnd();
//
//   @override
//   Stream<PhotoPageState> mapEventToState(PhotoPageEvent event) async* {
//     final currentState = state.clone();
//     print("in mapEventToState $event ${_hasEndBeenReached(currentState)}");
//     if (event is PhotoPageFetchEvent && !_hasEndBeenReached(currentState)) {
//       // yield PhotoPageStateLoading(photos: currentState.photos);
//       print('working on PhotoPageFetchEvent page: ${event.page}');
//       try {
//         if (currentState is PhotoPageStateInitial) {
//           final Pagination<AgnosticMedia> photoPage =
//               (await this.mediaRepo.getPhotosByPage(event.page));
//           print("got first photoPage: $photoPage");
//           yield PhotoPageStateSuccess(photos: photoPage);
//         } else if (currentState is PhotoPageStateSuccess) {
//           if (currentState.photos.page >= event.page) {
//             print("page already loaded - yielding same state");
//             yield currentState;
//           } else {
//             final photos = await this.mediaRepo.getPhotosByPage(event.page);
//             print("got photos: $photos");
//
//             yield photos.items.isEmpty
//                 ? currentState.copyWith()
//                 : currentState.copyWith(newPhotos: photos);
//           }
//         }
//       } catch (err) {
//         print("error getting Photo Page err: $err");
//         yield PhotoPageStateFailure(errorMessage: err.toString());
//       }
//     } else if (event is PhotoPageResetEvent) {
//       yield PhotoPageStateInitial();
//     }
//   }
//
//   @override
//   Stream<Transition<PhotoPageEvent, PhotoPageState>> transformEvents(
//       events, transitionFn) {
//     return events
//         .distinct((PhotoPageEvent previous, PhotoPageEvent next) {
//           if (previous == next) {
//             if (next.timeEmitted - previous.timeEmitted > 100) {
//               return false;
//             }
//             return true;
//           }
//           return false;
//         })
//         .debounceTime(const Duration(milliseconds: 50))
//         .switchMap(transitionFn);
//   }
//
// // @override
// // Stream<Transition<PhotoPageEvent, PhotoPageState>> transformEvents(
// //     Stream<PhotoPageEvent> events,
// //     TransitionFunction<PhotoPageEvent, PhotoPageState> transitionFn) {
// //   return events
// //       .debounceTime(const Duration(milliseconds: 300))
// //       .switchMap((transitionFn));
// // }
// }
