import 'package:equatable/equatable.dart';

class MediaDevice extends Equatable {
  final bool isAll;
  final String deviceId;
  final int count;

  const MediaDevice({this.deviceId, this.count, this.isAll = false});

  factory MediaDevice.fromJson(Map<String, dynamic> json) {
    return MediaDevice(
        deviceId: json['device_id'].toString(),
        count: int.parse(json['count']));
  }

  factory MediaDevice.allOption(int count) {
    return MediaDevice(deviceId: 'All', count: count, isAll: true);
  }

  @override
  List<Object> get props => [isAll, deviceId];
}
