import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';
import 'package:photostore_flutter/models/event/photo_page_event.dart';
import 'package:photostore_flutter/models/state/photo_page_state.dart';
import 'package:photostore_flutter/services/photo_page_repository.dart';

class PhotoPageBloc extends Bloc<PhotoPageEvent, PhotoPageState> {
  final PhotoPageRepository photoPageRepo;

  PhotoPageBloc(this.photoPageRepo) : super(PhotoPageStateInitial());

  // @override
  // Stream<Transition<PhotoPageEvent, PhotoPageState>> transformEvents(
  //   Stream<PhotoPageEvent> events,
  //   TransitionFunction<PhotoPageEvent, PhotoPageState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 500)),
  //     transitionFn,
  //   );
  // }
  bool _hasEndBeenReached(PhotoPageState state) =>
      state is PhotoPageStateSuccess &&
          state.photos.page * state.photos.perPage >= state.photos.total;


  @override
  Stream<PhotoPageState> mapEventToState(PhotoPageEvent event) async* {
    final currentState = state;
    if (event is PhotoPageFetchEvent && !_hasEndBeenReached(currentState)) {
      try {
        if (currentState is PhotoPageStateInitial) {
          final Pagination<Photo> photoPage = await this.photoPageRepo
              .getPhotosByPage(1);
          yield PhotoPageStateSuccess(photos: photoPage);
          return;
        }
        if (currentState is PhotoPageStateSuccess) {
          final photos = await await this.photoPageRepo.getPhotosByPage(
              currentState.photos.page + 1);
          yield photos.items.isEmpty
              ? currentState.copyWith()
              : PhotoPageStateSuccess(
              photos: photos
          );
        }
      } catch (_) {
        yield PhotoPageStateFailure();
      }
    }


// @override
// Stream<S> transform(StreamTransformer<PhotoPageState, S> streamTransformer) {
//
// }
  }
}
