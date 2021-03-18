import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/photo_diff_request.dart';

import 'media_contents.dart';

abstract class AgnosticMedia extends Equatable {
  final String id;
  final String deviceId;
  final String nativeId;
  final String filename;
  final DateTime creationDate;
  final DateTime modifiedDate;
  final Future<MediaContents> thumbnail;
  final ImageProvider thumbnailProvider;
  final Function getThumbnailProviderOfSize;
  final int width;
  final int height;
  final double longitude;
  final double latitude;

  const AgnosticMedia({
    this.id,
    this.creationDate,
    this.modifiedDate,
    this.filename,
    this.thumbnail,
    this.thumbnailProvider,
    this.getThumbnailProviderOfSize,
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
