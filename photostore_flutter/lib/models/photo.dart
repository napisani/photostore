import 'package:equatable/equatable.dart';
import 'package:photostore_flutter/models/agnostic_media.dart';

class Photo extends AgnosticMedia {
  final String id;
  final String checksum;
  final String gphotoId;
  final String mimeType;
  final DateTime creationDate;
  final String filename;

  const Photo(
      {this.id,
      this.checksum,
      this.gphotoId,
      this.mimeType,
      this.creationDate,
      this.filename}): super(id: id, creationDate: creationDate);

  @override
  List<Object> get props =>
      [id, checksum, gphotoId, mimeType, creationDate, filename];
}
