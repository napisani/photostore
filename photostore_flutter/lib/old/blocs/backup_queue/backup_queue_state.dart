// import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:photostore_flutter/models/agnostic_media.dart';
//
// abstract class BackupQueueState extends Equatable {
//   const BackupQueueState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class BackupQueueStateInitial extends BackupQueueState {
//   const BackupQueueStateInitial() : super();
// }
//
// class BackupQueueStateSuccess extends BackupQueueState {
//   final List<AgnosticMedia> queuedPhotos;
//   final int backedUpPhotoCount;
//   final String lastBackedUpPhotoId;
//   final DateTime lastBackedUpPhotoCreateDate;
//
//   const BackupQueueStateSuccess(
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
// class BackupQueueStateLoading extends BackupQueueState {
//   final int queueCount;
//
//   const BackupQueueStateLoading({this.queueCount});
//
//   List<Object> get props => [...super.props, queueCount];
// }
//
// class BackupQueueStateFailure extends BackupQueueState {
//   final String errorMessage;
//
//   const BackupQueueStateFailure({@required this.errorMessage}) : super();
//
//   @override
//   List<Object> get props => [...super.props, errorMessage];
// }
