// import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:photostore_flutter/models/agnostic_media.dart';
//
// abstract class PhotoBackupState extends Equatable {
//   const PhotoBackupState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class PhotoBackupStateInitial extends PhotoBackupState {
//   const PhotoBackupStateInitial() : super();
// }
//
// class PhotoBackupStateSuccess extends PhotoBackupState {
//   final List<AgnosticMedia> queuedPhotos;
//   final int backedUpPhotoCount;
//   final String lastBackedUpPhotoId;
//   final DateTime lastBackedUpPhotoCreateDate;
//
//   const PhotoBackupStateSuccess(
//       {@required this.backedUpPhotoCount,
//       this.lastBackedUpPhotoId = '',
//       this.lastBackedUpPhotoCreateDate,
//       this.queuedPhotos})
//       : super();
//
//   @override
//   List<Object> get props => [
//         ...super.props,
//         backedUpPhotoCount,
//         lastBackedUpPhotoId,
//         lastBackedUpPhotoCreateDate
//       ];
// }
//
// class PhotoBackupStateFailure extends PhotoBackupState {
//   final String errorMessage;
//
//   const PhotoBackupStateFailure({@required this.errorMessage}) : super();
//
//   @override
//   List<Object> get props => [...super.props, errorMessage];
// }
