import 'agnostic_media.dart';

class MobilePhoto extends AgnosticMedia {
  final String checksum;
  final String gphotoId;
  final String mimeType;
  final String filename;

  const MobilePhoto(
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
