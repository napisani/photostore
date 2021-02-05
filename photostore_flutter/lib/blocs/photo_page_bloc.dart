import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photostore_flutter/blocs/app_settings_bloc.dart';
import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/app_settings.dart';
import 'package:photostore_flutter/models/event/photo_page_event.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/state/app_settings_state.dart';
import 'package:photostore_flutter/models/state/photo_page_state.dart';
import 'package:photostore_flutter/services/media_repository.dart';

class PhotoPageBloc extends Bloc<PhotoPageEvent, PhotoPageState> {
  final MediaRepository mediaRepo;
  final AppSettingsBloc appSettingsBloc;
  AppSettings _appSettings;

  PhotoPageBloc({@required this.mediaRepo, @required this.appSettingsBloc})
      : super(PhotoPageStateInitial()) {
    this.appSettingsBloc.listen((AppSettingsState appSettingsState) {
      if (appSettingsState is AppSettingsSuccess) {
        print("PhotoPageBloc received new app settings!");
        _appSettings = appSettingsState.appSettings;
        this.mediaRepo.setAppSettings(_appSettings);
        if (!(state is PhotoPageStateInitial)) {
          print("PhotoPageBloc adding reset event");
          this.add(PhotoPageResetEvent());
        }
      }
    });
    if (this.appSettingsBloc.state is AppSettingsInitial) {
      this.appSettingsBloc.loadSettings();
    } else if (this.appSettingsBloc.state is AppSettingsSuccess) {
      print('using preexisting bloc state');
      if (_appSettings !=
          (this.appSettingsBloc.state as AppSettingsSuccess).appSettings) {
        _appSettings =
            (this.appSettingsBloc.state as AppSettingsSuccess).appSettings;
        this.mediaRepo.setAppSettings(_appSettings);
        add(PhotoPageResetEvent());
      }
    }
  }

  bool _hasEndBeenReached(PhotoPageState state) =>
      state is PhotoPageStateSuccess && state.reachedEnd();

  @override
  Stream<PhotoPageState> mapEventToState(PhotoPageEvent event) async* {
    final currentState = state.clone();
    print("in mapEventToState $event ${_hasEndBeenReached(currentState)}");
    if (event is PhotoPageFetchEvent && !_hasEndBeenReached(currentState)) {
      // yield PhotoPageStateLoading(photos: currentState.photos);
      print('made it here');
      try {
        if (currentState is PhotoPageStateInitial) {
          final Pagination<AgnosticMedia> photoPage =
              (await this.mediaRepo.getPhotosByPage(1));
          print("got first photoPage: $photoPage");
          yield PhotoPageStateSuccess(photos: photoPage);
        } else if (currentState is PhotoPageStateSuccess) {
          final photos = await this
              .mediaRepo
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
    } else if (event is PhotoPageResetEvent) {
      yield PhotoPageStateInitial();
    }
  }

  @override
  Stream<Transition<PhotoPageEvent, PhotoPageState>> transformEvents(events, transitionFn) {
    return events.switchMap(transitionFn);
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
