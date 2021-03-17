import 'dart:io';

import 'agnostic_media.dart';

class MobilePhoto extends AgnosticMedia {
  final String checksum;
  final String gphotoId;
  final String mimeType;
  final Future<File> originFile;

  const MobilePhoto({
    id,
    this.checksum,
    this.gphotoId,
    this.mimeType,
    creationDate,
    modifiedDate,
    filename,
    thumbnail,
    thumbnailProvider,
    getThumbnailProviderOfSize,
    this.originFile,
    nativeId,
    deviceId,
    width,
    height,
    longitude,
    latitude,
  }) : super(
            id: id,
            creationDate: creationDate,
            thumbnail: thumbnail,
            thumbnailProvider: thumbnailProvider,
            getThumbnailProviderOfSize: getThumbnailProviderOfSize,
            nativeId: nativeId,
            deviceId: deviceId,
            modifiedDate: modifiedDate,
            width: width,
            height: height,
            longitude: longitude,
            latitude: latitude,
            filename: filename);

  @override
  List<Object> get props => [...super.props, checksum, gphotoId, mimeType];

  Map<String, dynamic> toJson() => {
        'id': id,
        'checksum': checksum,
        'gphoto_id': gphotoId,
        'mime_type': mimeType,
        'creation_date': creationDate.toString(),
        'modified_date': modifiedDate.toString(),
        'filename': filename,
        'native_id': nativeId,
        'device_id': deviceId,
        'width': width,
        'height': height,
        'longitude': longitude,
        'latitude': latitude
      };
}
