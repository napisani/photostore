// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:photostore_flutter/blocs/photo_backup/photo_backup_state.dart';
// import 'package:photostore_flutter/models/agnostic_media.dart';
// import 'package:photostore_flutter/models/photo.dart';
// import 'package:photostore_flutter/services/media_api_repository.dart';
//
// class PhotoBackupBloc extends Cubit<PhotoBackupState> {
//   final MediaAPIRepository mediaAPIRepo;
//
//   PhotoBackupBloc({@required this.mediaAPIRepo})
//       : super(PhotoBackupStateInitial()) {
//     this.mediaAPIRepo.appSettingsBloc.listen((state) {
//       if (!(state is PhotoBackupStateInitial)) {
//         print("PhotoBackupBloc got new app settings calling getInitialStats ");
//         this.getInitialStats();
//       }
//     });
//   }
//
//   void getInitialStats() async {
//     try {
//       Photo p = await this.mediaAPIRepo.getLastBackedUpPhoto();
//       emit(PhotoBackupStateSuccess(
//           backedUpPhotoCount: 1,
//           lastBackedUpPhotoId: p.id,
//           lastBackedUpPhotoCreateDate: p.creationDate));
//     } catch (err) {
//       print("error PhotoBackupBloc.getInitialStats err: $err");
//       emit(PhotoBackupStateFailure(errorMessage: err.toString()));
//     }
//   }
//
//   void queueMobilePhotosForBackup(List<AgnosticMedia> photos) async {}
// }
