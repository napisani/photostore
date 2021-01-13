import 'package:equatable/equatable.dart';

/*
  id?: number;
  checksum?: string;
  gphotoId?: string;
  mimeType?: string;
  creationDate?: Date;
  filename?: string;
 */
class Photo extends Equatable {
  final int id;
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
      this.filename});

  @override
  List<Object> get props =>
      [id, checksum, gphotoId, mimeType, creationDate, filename];
}
