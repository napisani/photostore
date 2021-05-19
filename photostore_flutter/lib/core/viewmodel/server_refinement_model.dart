import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:photostore_flutter/core/model/photo_date_ranges.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/service/album/album_api_service.dart';
import 'package:photostore_flutter/core/service/app_settings_service.dart';
import 'package:photostore_flutter/core/service/media/server_media_service.dart';
import 'package:photostore_flutter/core/service/server_refinement_service.dart';
import 'package:photostore_flutter/core/viewmodel/abstract_view_model.dart';
import 'package:photostore_flutter/locator.dart';

class ServerRefinementModel extends AbstractViewModel {
  List<MediaDevice> deviceOptions = [];
  List<PhotoAlbum> albumOptions = [];
  PhotoDateRanges dateRanges = PhotoDateRanges();

  bool _deviceExpanded = false;
  bool _albumExpanded = false;
  bool _dateExpanded = false;

  final ServerMediaService _serverMediaService = locator<ServerMediaService>();
  final AppSettingsService _appSettingsService = locator<AppSettingsService>();
  final ServerRefinementService _serverRefinementService =
      locator<ServerRefinementService>();
  final AlbumAPIService _albumAPIService = locator<AlbumAPIService>();

  ServerRefinementModel() {
    reinit();
  }

  void toggleExpandDate() {
    this._dateExpanded = !this._dateExpanded;
    notifyListeners();
  }

  void toggleExpandAlbum() {
    this._albumExpanded = !this._albumExpanded;
    notifyListeners();
  }

  void toggleExpandDevice() {
    this._deviceExpanded = !this._deviceExpanded;
    notifyListeners();
  }

  bool get deviceExpanded => _deviceExpanded;

  bool get dateExpanded => _dateExpanded;

  bool get albumExpanded => _albumExpanded;

  bool isAlbumSelected() =>
      _serverRefinementService.getAlbumFilter() != PhotoAlbum.allOption();

  bool isDeviceSelected() =>
      _serverRefinementService.getDeviceFilter() != MediaDevice.allOption(0);

  bool isDateSelected() => _serverRefinementService.getDateFilter() != null;

  void clearAll() {
    clearDevice();
    clearDate();
    clearAlbum();
  }

  void clearDevice() => selectDevice(MediaDevice.allOption(0));

  void clearAlbum() => selectAlbum(PhotoAlbum.allOption());

  void clearDate() => selectDate(null);

  selectDevice(MediaDevice mediaDevice) {
    this._serverRefinementService.setDeviceFilter(mediaDevice);
    notifyListeners();
  }

  selectAlbum(PhotoAlbum album) {
    this._serverRefinementService.setAlbumFilter(album);
    notifyListeners();
  }

  selectDate(DateTime dateTime) {
    this._serverRefinementService.setDateTimeFilter(dateTime);
    notifyListeners();
  }

  MediaDevice get selectedDevice => _serverRefinementService.getDeviceFilter();

  PhotoAlbum get selectedAlbum => _serverRefinementService.getAlbumFilter();

  DateTime get selectedDate => _serverRefinementService.getDateFilter();

  void reinit() async {
    this.screenStatus = ScreenStatus.uninitialized();
    if (this._appSettingsService.areServerSettingsConfigured()) {
      await loadFilterOptions();
    } else {
      this.screenStatus = ScreenStatus.disabled(DISABLED_SERVER_FEATURE_TEXT);
      notifyListeners();
    }
  }

  Future<void> loadFilterOptions() async {
    this.screenStatus = ScreenStatus.loading(this);
    notifyListeners();
    try {
      await _loadDeviceOptions();
      await _loadAlbumOptions();
      await _loadPhotoDateRanges();
      this.screenStatus = ScreenStatus.success();
    } catch (err, s) {
      print(
          '[ServerRefinementModel] got error in loadMediaDeviceOptions ${err.toString()} stack: $s');
      this.deviceOptions = [];
      this.screenStatus = ScreenStatus.error(err.toString());
    }
    notifyListeners();
  }

  Future<void> _loadDeviceOptions() async {
    this.deviceOptions = await this._serverMediaService.getDevices();
    this.deviceOptions = [
      MediaDevice.allOption(
          deviceOptions.map((e) => e.count).fold(0, (p, c) => p + c)),
      ...deviceOptions
    ];
    print('built device options $deviceOptions');
  }

  Future<void> _loadAlbumOptions() async {
    this.albumOptions = await this._albumAPIService.getAllAlbums();
    this.albumOptions = [PhotoAlbum.allOption(), ...albumOptions];
    print('built album options $albumOptions');
  }

  Future<void> _loadPhotoDateRanges() async {
    this.dateRanges = await this._serverMediaService.getPhotoDateRanges();
    print('got photo date ranges  $dateRanges');
  }
}
