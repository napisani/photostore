import 'package:equatable/equatable.dart';
import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/pagination.dart';

abstract class PhotoPageState extends Equatable {
  final Pagination<AgnosticMedia> photos;

  const PhotoPageState({this.photos = const Pagination<AgnosticMedia>()});

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
  List<Object> get props => [photos];

  @override
  String toString() =>
      'PhotoStateSuccess type: ${this.runtimeType} { photos.items.length: ${photos?.items?.length}, page: ${photos?.page} }';
}

class PhotoPageStateInitial extends PhotoPageState {}

class PhotoPageStateLoading extends PhotoPageState {
  PhotoPageStateLoading({photos}) : super(photos: photos);
}

class PhotoPageStateFailure extends PhotoPageState {
  final String errorMessage;

  PhotoPageStateFailure({this.errorMessage, photos}) : super(photos: photos);
}

class PhotoPageStateSuccess extends PhotoPageState {
  PhotoPageStateSuccess({photos}) : super(photos: photos);

  PhotoPageStateSuccess copyWith({Pagination<AgnosticMedia> newPhotos}) {
    return PhotoPageStateSuccess(photos: super._copyPageWith(newPhotos));
  }
}
