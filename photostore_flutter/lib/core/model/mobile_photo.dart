import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

import 'agnostic_media.dart';
import 'app_settings.dart';
import 'future_memory_image.dart';
import 'media_contents.dart';

typedef FileGetterFunction = Future<File> Function();

class MobilePhoto extends AgnosticMedia {
  final String checksum;
  final String gphotoId;
  final String mimeType;
  final FileGetterFunction getOriginFile;

  const MobilePhoto({
    id,
    this.checksum,
    this.gphotoId,
    this.mimeType,
    assetType,
    creationDate,
    modifiedDate,
    filename,
    getThumbnail,
    thumbnailProvider,
    thumbnailOfDeviceSizeProvider,
    // getThumbnailProviderOfSize,
    this.getOriginFile,
    nativeId,
    deviceId,
    width,
    height,
    longitude,
    latitude,
  }) : super(
            id: id,
            creationDate: creationDate,
            getThumbnail: getThumbnail,
            thumbnailProvider: thumbnailProvider,
            thumbnailOfDeviceSizeProvider: thumbnailOfDeviceSizeProvider,
            // getThumbnailProviderOfSize: getThumbnailProviderOfSize,
            nativeId: nativeId,
            deviceId: deviceId,
            modifiedDate: modifiedDate,
            width: width,
            height: height,
            longitude: longitude,
            latitude: latitude,
            filename: filename,
            assetType: assetType);

  factory MobilePhoto.fromAssetPathEntity(
          AssetEntity item, AppSettings settings) =>
      MobilePhoto(
          id: item.id,
          checksum: '',
          gphotoId: '',
          assetType: item.typeInt,
          filename: item.title,
          creationDate: item.createDateTime,
          modifiedDate: item.modifiedDateTime,
          width: item.width,
          height: item.height,
          longitude: item.longitude,
          latitude: item.latitude,
          nativeId: item.id,
          deviceId: settings.deviceID,
          // originFile: ()=> item.loadFile(isOrigin: false),
          getOriginFile: () => item.originFile,
          // getThumbnailProviderOfSize: (double width, double height,
          //         {BuildContext context, bool precache}) =>
          //     FutureMemoryImage(() => item
          //         .thumbDataWithSize(width.round(), height.round())
          //         .asStream()
          //         .first),

          thumbnailOfDeviceSizeProvider: FutureMemoryImage(() => item
              .thumbDataWithSize(
                  settings.deviceWidth.round(), settings.deviceHeight.round())
              .asStream()
              .first),
          thumbnailProvider:
              FutureMemoryImage(() => item.thumbData.asStream().first),
          getThumbnail: () => item.thumbData
              .asStream()
              .map((bin) => MediaContents.memory(bin))
              .first,
          mimeType: '');

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
