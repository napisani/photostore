import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/event/photo_page_event.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/state/photo_page_state.dart';
import 'package:photostore_flutter/services/media_repository.dart';

class PhotoPageBloc extends Bloc<PhotoPageEvent, PhotoPageState> {
  final MediaRepository _mediaRepo;

  PhotoPageBloc(this._mediaRepo) : super(PhotoPageStateInitial());

  bool _hasEndBeenReached(PhotoPageState state) =>
      state is PhotoPageStateSuccess && state.reachedEnd();

  @override
  Stream<PhotoPageState> mapEventToState(PhotoPageEvent event) async* {
    final currentState = state;
    print("in mapEventToState $event ${_hasEndBeenReached(currentState)}");
    if (event is PhotoPageFetchEvent && !_hasEndBeenReached(currentState)) {
      yield PhotoPageStateLoading(photos: currentState.photos);

      try {
        if (currentState is PhotoPageStateInitial) {
          final Pagination<AgnosticMedia> photoPage =
          (await this._mediaRepo.getPhotosByPage(1));
          print("got first photoPage: $photoPage");
          yield PhotoPageStateSuccess(photos: photoPage);
        }
        if (currentState is PhotoPageStateSuccess) {
          final photos = await this
              ._mediaRepo
              .getPhotosByPage(currentState.photos.page + 1);
          print("got photos: $photos");

          yield photos.items.isEmpty
              ? currentState.copyWith()
              : currentState.copyWith(newPhotos: photos);
        }
      } catch (err) {
        print("error getting Photo Page err: $err");
        yield PhotoPageStateFailure(errorMessage: err.toString());
      }
    }
  }

// @override
// Stream<Transition<PhotoPageEvent, PhotoPageState>> transformEvents(
//     Stream<PhotoPageEvent> events,
//     TransitionFunction<PhotoPageEvent, PhotoPageState> transitionFn) {
//   return events
//       .debounceTime(const Duration(milliseconds: 300))
//       .switchMap((transitionFn));
// }
}
