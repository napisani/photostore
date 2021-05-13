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

  final ServerMediaService _serverMediaService = locator<ServerMediaService>();
  final AppSettingsService _appSettingsService = locator<AppSettingsService>();
  final ServerRefinementService _serverRefinementService =
      locator<ServerRefinementService>();
  final AlbumAPIService _albumAPIService = locator<AlbumAPIService>();

  ServerRefinementModel() {
    reinit();
  }

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

  get selectedDevice => _serverRefinementService.getDeviceFilter();

  get selectedAlbum => _serverRefinementService.getAlbumFilter();

  get selectedDate => _serverRefinementService.getDateFilter();

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
