import 'package:equatable/equatable.dart';
import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/pagination.dart';

abstract class PhotoPageState extends Equatable {
  final Pagination<AgnosticMedia> photos;
  final int stateId;
  static int _maxStateId = 1;

  PhotoPageState({this.photos = const Pagination<AgnosticMedia>()})
      : stateId = _maxStateId + 1 {
    _maxStateId++;
  }

  PhotoPageState clone();

  bool reachedEnd() => photos.page * photos.perPage >= photos.total;

  _copyPageWith(Pagination<AgnosticMedia> photos) {
    Pagination<AgnosticMedia> newPage = Pagination<AgnosticMedia>(
        perPage: photos.perPage,
        total: photos.total,
        page: photos.page,
        items: this.photos?.items == null ? photos.items : this.photos.items
          ..addAll(photos.items));

    return newPage;
  }

  @override
  List<Object> get props => [photos, stateId];

  @override
  String toString() =>
      'PhotoStateSuccess type: ${this.runtimeType} { photos.items.length: ${photos?.items?.length}, page: ${photos?.page} }';
}

class PhotoPageStateInitial extends PhotoPageState {
  @override
  PhotoPageState clone() {
    return PhotoPageStateInitial();
  }
}

class PhotoPageStateLoading extends PhotoPageState {
  PhotoPageStateLoading({photos}) : super(photos: photos);

  @override
  PhotoPageState clone() {
    return PhotoPageStateLoading(photos: this.photos);
  }
}

class PhotoPageStateFailure extends PhotoPageState {
  final String errorMessage;

  PhotoPageStateFailure({this.errorMessage, photos}) : super(photos: photos);

  @override
  PhotoPageState clone() {
    return PhotoPageStateFailure(
        errorMessage: this.errorMessage, photos: this.photos);
  }
}

class PhotoPageStateSuccess extends PhotoPageState {
  PhotoPageStateSuccess({photos}) : super(photos: photos);

  PhotoPageStateSuccess copyWith({Pagination<AgnosticMedia> newPhotos}) {
    return PhotoPageStateSuccess(photos: super._copyPageWith(newPhotos));
  }

  @override
  PhotoPageState clone() {
    return PhotoPageStateSuccess(photos: this.photos);
  }
}
