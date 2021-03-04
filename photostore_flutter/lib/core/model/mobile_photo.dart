import 'dart:io';

import 'agnostic_media.dart';

class MobilePhoto extends AgnosticMedia {
  final String checksum;
  final String gphotoId;
  final String mimeType;
  final String filename;
  final  Future<File> originFile;

  const MobilePhoto(
      {id,
      this.checksum,
      this.gphotoId,
      this.mimeType,
      creationDate,
      this.filename,
      thumbnail,
      thumbnailProvider,
      getThumbnailProviderOfSize,
      this.originFile})
      : super(
            id: id,
            creationDate: creationDate,
            thumbnail: thumbnail,
            thumbnailProvider: thumbnailProvider,
            getThumbnailProviderOfSize: getThumbnailProviderOfSize);

  @override
  List<Object> get props =>
      [...super.props, checksum, gphotoId, mimeType, filename];
}
