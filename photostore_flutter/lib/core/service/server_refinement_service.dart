import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:rxdart/rxdart.dart';

const String DEVICE_ID_FILTER = 'device_id';

class ServerRefinementService {
  final BehaviorSubject<PhotoAlbum> _albumFilter =
      BehaviorSubject.seeded(PhotoAlbum.allOption());

  final BehaviorSubject<MediaDevice> _deviceFilter =
      BehaviorSubject.seeded(MediaDevice.allOption(0));

  void setDeviceFilter(MediaDevice mediaDevice) {
    this._deviceFilter.sink.add(mediaDevice);
  }

  void setAlbumFilter(PhotoAlbum album) {
    this._albumFilter.sink.add(album);
  }

  MediaDevice getDeviceFilter() => _deviceFilter.value;

  PhotoAlbum getAlbumFilter() => _albumFilter.value;

  void dispose() {
    _deviceFilter.close();
    _albumFilter.close();
  }
}
