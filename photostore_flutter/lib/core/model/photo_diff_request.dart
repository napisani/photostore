import 'package:flutter/cupertino.dart';

class PhotoDiffRequest {
  final String deviceId;
  final String nativeId;
  final DateTime modifiedDate;
  final String checksum;

  PhotoDiffRequest(
      {this.deviceId,
      @required this.nativeId,
      @required this.modifiedDate,
      this.checksum});

  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'native_id': nativeId,
        'modified_date': modifiedDate.toString(),
        'checksum': checksum
      };
}
