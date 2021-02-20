// import 'dart:async';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:photostore_flutter/blocs/backup_queue/backup_queue_event.dart';
// import 'package:photostore_flutter/blocs/backup_queue/backup_queue_state.dart';
// import 'package:photostore_flutter/blocs/photo_page/mobile_photo_page_bloc.dart';
// import 'package:photostore_flutter/blocs/photo_page/photo_page_event.dart';
// import 'package:photostore_flutter/blocs/photo_page/photo_page_state.dart';
// import 'package:photostore_flutter/models/agnostic_media.dart';
// import 'package:photostore_flutter/models/photo.dart';
// import 'package:photostore_flutter/services/media_api_repository.dart';
//
// class BackupQueueBloc extends Bloc<BackupQueueEvent, BackupQueueState> {
//   final MobilePhotoPageBloc _mobileBloc;
//   final MediaAPIRepository _mediaAPIRepo;
//
//   BackupQueueBloc(this._mobileBloc,this._mediaAPIRepo) : super(BackupQueueStateInitial());
//
//   @override
//   Stream<BackupQueueState> mapEventToState(BackupQueueEvent event) async* {
//     if(event is PhotoBackupResetEvent) {
//       AgnosticMedia lastBackedUpPhoto = await this._mediaAPIRepo.getLastBackedUpPhoto();
//
//       yield* _prepareBackup(lastBackedUpPhoto);
//     }
//   }
//
//   Stream<BackupQueueState> _prepareBackup(AgnosticMedia lastBackedUpPhoto) async* {
//     // preparingPhotoBackupQueue = true;
//     yield BackupQueueStateLoading();
//     // _mobileBloc = BlocProvider.of<MobilePhotoPageBloc>(context);
//     _mobileBloc.add(PhotoPageResetEvent());
//
//
//     _mobileBloc.pipe(streamConsumer)
//     StreamSubscription sub;
//     sub = _mobileBloc.listen((state) async* {
//       print('got page state $state');
//       if (state is PhotoPageStateSuccess) {
//         if (state.reachedEnd()) {
//           print('the end was reached!');
//           _queuePhotosToBackup(state, backupState);
//           sub.cancel();
//         } else if (state.photos.items?.last?.creationDate != null) {
//           if (state.photos.items.last.creationDate
//                   .compareTo(backupState.lastBackedUpPhotoCreateDate) >
//               0) {
//             _mobileBloc.add(new PhotoPageFetchEvent(state.photos.page + 1));
//           } else {
//             _queuePhotosToBackup(state, backupState);
//             sub.cancel();
//           }
//         }
//       } else if (state is PhotoPageStateFailure) {
//         print('photo page error: ${state.errorMessage}');
//         // preparingPhotoBackupQueue = false;
//         yield BackupQueueStateFailure(errorMessage: state.errorMessage);
//         sub.cancel();
//       } else {
//         sub.cancel();
//       }
//     });
//   }
//
//   void _queuePhotosToBackup(
//       PhotoPageState state, AgnosticMedia lastBackedUpPhoto) {
//     List<AgnosticMedia> photosToBackup = state.photos.items;
//     photosToBackup.removeWhere((element) =>
//         element.creationDate
//             .compareTo(lastBackedUpPhoto.creationDate) <=
//         0);
//     this.preparingPhotoBackupQueue = false;
//     print('ready to queue up photosToBackup: $photosToBackup');
//   }
// }
