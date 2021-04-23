class MediaDevice {
  final String deviceId;
  final String count;

  const MediaDevice({this.deviceId, this.count});

  factory MediaDevice.fromJson(Map<String, dynamic> json) {
    return MediaDevice(
        deviceId: json['device_id'].toString(), count: json['count']);
  }
}
