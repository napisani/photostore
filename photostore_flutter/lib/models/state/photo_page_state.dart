import 'package:equatable/equatable.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';

abstract class PhotoPageState extends Equatable {
  final Pagination<Photo> photos;

  const PhotoPageState({this.photos = const Pagination<Photo>()});

  bool reachedEnd() => photos.page * photos.perPage >= photos.total;

  //
  _copyPageWith(Pagination<Photo> photos) {
    Pagination<Photo> newPage = Pagination<Photo>(
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

  PhotoPageStateSuccess copyWith({Pagination<Photo> newPhotos}) {
    return PhotoPageStateSuccess(photos: super._copyPageWith(newPhotos));
  }
}
