import 'package:equatable/equatable.dart';
import 'package:photostore_flutter/models/agnostic_media.dart';

class Photo extends AgnosticMedia {
  final String checksum;
  final String gphotoId;
  final String mimeType;
  final String filename;

  const Photo(
      {id,
        this.checksum,
        this.gphotoId,
        this.mimeType,
        creationDate,
        this.filename,
        thumbnail})
      : super(id: id, creationDate: creationDate, thumbnail: thumbnail);

  @override
  List<Object> get props =>
      [...super.props, checksum, gphotoId, mimeType, filename];
}
