import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:rxdart/rxdart.dart';

const String DEVICE_ID_FILTER = 'device_id';

class ServerRefinementService {


  final BehaviorSubject<MediaDevice> _deviceFilter =
      BehaviorSubject.seeded(MediaDevice.allOption(0));

  void setDeviceFilter(MediaDevice mediaDevice) {
    this._deviceFilter.sink.add(mediaDevice);
  }

  MediaDevice getDeviceFilter() => _deviceFilter.value;

  void dispose() {
    _deviceFilter.close();
  }
}
