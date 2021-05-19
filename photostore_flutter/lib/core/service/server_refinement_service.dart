import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:rxdart/rxdart.dart';

const String DEVICE_ID_FILTER = 'device_id';

const String ALBUM_FILTER = 'album_name';

const String MODIFIED_DATE_FILTER = 'before_modified_date';

class ServerRefinementService {
  final BehaviorSubject<PhotoAlbum> _albumFilter =
      BehaviorSubject.seeded(PhotoAlbum.allOption());

  final BehaviorSubject<MediaDevice> _deviceFilter =
      BehaviorSubject.seeded(MediaDevice.allOption(0));

  final BehaviorSubject<DateTime> _dateFilter = BehaviorSubject.seeded(null);

  void setDeviceFilter(MediaDevice mediaDevice) {
    this._deviceFilter.sink.add(mediaDevice);
  }

  void setAlbumFilter(PhotoAlbum album) {
    this._albumFilter.sink.add(album);
  }

  void setDateTimeFilter(DateTime dateTime) {
    this._dateFilter.sink.add(dateTime);
  }

  MediaDevice getDeviceFilter() => _deviceFilter.value;

  PhotoAlbum getAlbumFilter() => _albumFilter.value;

  DateTime getDateFilter() => _dateFilter.value;

  bool hasFilter() =>
      getDateFilter() != null ||
      getAlbumFilter() != PhotoAlbum.allOption() ||
      getDeviceFilter() != MediaDevice.allOption(0);

  void dispose() {
    _deviceFilter.close();
    _albumFilter.close();
    _dateFilter.close();
  }
}
