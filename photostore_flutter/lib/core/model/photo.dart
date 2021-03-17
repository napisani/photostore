import 'agnostic_media.dart';

class Photo extends AgnosticMedia {
  final String checksum;
  final String gphotoId;
  final String mimeType;

  const Photo(
      {id,
      this.checksum,
      this.gphotoId,
      this.mimeType,
      creationDate,
      modifiedDate,
      filename,
      thumbnail,
      thumbnailProvider,
      getThumbnailProviderOfSize,
      nativeId,
      deviceId,
      width,
      height,
      longitude,
      latitude})
      : super(
            id: id,
            creationDate: creationDate,
            thumbnail: thumbnail,
            thumbnailProvider: thumbnailProvider,
            getThumbnailProviderOfSize: getThumbnailProviderOfSize,
            modifiedDate: modifiedDate,
            nativeId: nativeId,
            deviceId: deviceId,
            width: width,
            height: height,
            longitude: longitude,
            latitude: latitude,
            filename: filename);



  @override
  List<Object> get props => [...super.props, checksum, gphotoId, mimeType];
}
