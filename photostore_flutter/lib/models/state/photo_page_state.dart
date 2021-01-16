import 'package:equatable/equatable.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';

abstract class PhotoPageState extends Equatable {
  const PhotoPageState();

  @override
  List<Object> get props => [];
}

class PhotoPageStateInitial extends PhotoPageState {}

class PhotoPageStateFailure extends PhotoPageState {}

class PhotoPageStateSuccess extends PhotoPageState {
  final Pagination<Photo> photos;

  const PhotoPageStateSuccess({this.photos});

  PhotoPageStateSuccess copyWith({Pagination<Photo> photos}) {
    Pagination<Photo> newPage = Pagination<Photo>(
        perPage: photos.perPage,
        total: photos.total,
        page: photos.page,
        items: this.photos.items..addAll(photos.items));

    return PhotoPageStateSuccess(
      photos: newPage,
    );
  }

  bool reachedEnd() => photos.page * photos.perPage >= photos.total;

  @override
  List<Object> get props => [photos];

  @override
  String toString() =>
      'PhotoStateSuccess { photos.items.length: ${photos?.items?.length}, page: ${photos?.page} }';
}
