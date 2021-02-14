import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../agnostic_media.dart';

abstract class PhotoBackupState extends Equatable {
  final int backedUpPhotoCount;
  final String lastBackedUpPhotoId;
  final DateTime lastBackedUpPhotoCreateDate;

  const PhotoBackupState({
    @required this.backedUpPhotoCount,
    this.lastBackedUpPhotoId = '',
    this.lastBackedUpPhotoCreateDate,
  });

  @override
  List<Object> get props =>
      [backedUpPhotoCount, lastBackedUpPhotoId, lastBackedUpPhotoCreateDate];
}

class PhotoBackupStateInitial extends PhotoBackupState {
  const PhotoBackupStateInitial()
      : super(
            backedUpPhotoCount: -1,
            lastBackedUpPhotoCreateDate: null,
            lastBackedUpPhotoId: '');
}

class PhotoBackupStateSuccess extends PhotoBackupState {
  final List<AgnosticMedia> queuedPhotos;

  const PhotoBackupStateSuccess(
      {@required int backedUpPhotoCount,
      String lastBackedUpPhotoId = '',
      DateTime lastBackedUpPhotoCreateDate,
      this.queuedPhotos})
      : super(
            backedUpPhotoCount: backedUpPhotoCount,
            lastBackedUpPhotoCreateDate: lastBackedUpPhotoCreateDate,
            lastBackedUpPhotoId: lastBackedUpPhotoId);
}

class PhotoBackupStateFailure extends PhotoBackupState {
  final String errorMessage;

  const PhotoBackupStateFailure({@required this.errorMessage})
      : super(
          backedUpPhotoCount: -1,
          lastBackedUpPhotoCreateDate: null,
          lastBackedUpPhotoId: '',
        );

  @override
  List<Object> get props => [...super.props, errorMessage];
}
