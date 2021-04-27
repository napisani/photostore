import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/photo_diff_request.dart';

import 'agnostic_media.dart';
import 'media_contents.dart';

class Photo extends AgnosticMedia {
  final String checksum;
  final String gphotoId;
  final String mimeType;

  const Photo({id,
    this.checksum,
    this.gphotoId,
    this.mimeType,
    creationDate,
    modifiedDate,
    filename,
    getThumbnail,
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
      getThumbnail: getThumbnail,
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

  factory Photo.fromJson(Map<String, dynamic> item, String url, Map<String, String> headers) {
    return Photo(
        id: item['id'].toString(),
        checksum: item['checksum'],
        gphotoId: item['gphoto_id'],
        filename: item['filename'],
        width: item['width'],
        height: item['height'],
        longitude: item['longitude'],
        latitude: item['latitude'],
        nativeId: item['native_id'],
        deviceId: item['device_id'],
        creationDate: DateTime.parse(item['creation_date']),
        modifiedDate: DateTime.parse(item['modified_date']),
        getThumbnailProviderOfSize: (double width, double height) =>
            NetworkImage(url, headers: headers),
        thumbnailProvider:  NetworkImage(url, headers: headers),
        getThumbnail: ()=>Future.value(MediaContents.url(url, headers: headers)),
        mimeType: item['mime_type']);
  }



  @override
  List<Object> get props => [...super.props, checksum, gphotoId, mimeType];
}
