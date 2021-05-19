import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/photo_diff_request.dart';

import 'media_contents.dart';

typedef MediaContentsGetterFunction = Future<MediaContents> Function();

typedef ThumbnailGetterFunction = ImageProvider Function(
    double width, double height,
    {BuildContext context, bool precache});

abstract class AgnosticMedia extends Equatable {
  final String id;
  final String deviceId;
  final String nativeId;
  final String filename;
  final int assetType;
  final DateTime creationDate;
  final DateTime modifiedDate;
  final MediaContentsGetterFunction getThumbnail;
  final ImageProvider thumbnailProvider;
  final ImageProvider thumbnailOfDeviceSizeProvider;
  // final ThumbnailGetterFunction getThumbnailProviderOfSize;
  final int width;
  final int height;
  final double longitude;
  final double latitude;

  const AgnosticMedia({
    this.id,
    this.creationDate,
    this.modifiedDate,
    this.assetType = 1,
    this.filename,
    this.getThumbnail,
    this.thumbnailProvider,
    this.thumbnailOfDeviceSizeProvider,
    // this.getThumbnailProviderOfSize,
    this.width,
    this.height,
    this.longitude,
    this.latitude,
    this.deviceId,
    this.nativeId,
  }) : super();

  toDiffRequest() => PhotoDiffRequest(
      nativeId: nativeId,
      modifiedDate: modifiedDate,
      checksum: '',
      deviceId: deviceId);

  @override
  List<Object> get props => [
        id,
        creationDate,
        modifiedDate,
        width,
        height,
        longitude,
        latitude,
        deviceId,
        nativeId,
        filename
      ];
}
