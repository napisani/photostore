import 'package:photostore_flutter/core/model/cancel_notifier.dart';
import 'package:photostore_flutter/core/model/pause_notifier.dart';
import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:photostore_flutter/core/model/progress_log.dart';
import 'package:photostore_flutter/core/repository/album/album_api_repository.dart';
import 'package:photostore_flutter/core/repository/album/album_mobile_repository.dart';
import 'package:photostore_flutter/locator.dart';

import 'backup_services.dart';

class AlbumBackupService {
  final AlbumAPIRepository _albumAPIRepo = locator<AlbumAPIRepository>();
  final AlbumMobileRepository _albumMobileRepo =
      locator<AlbumMobileRepository>();

  Future<void> doAlbumBackup(
      {BackupProgressHandler progressNotify,
      CancelNotifier canceller,
      PauseNotifier pauseNotifier,
      ProgressLog progressLog}) async {
    Map<String, PhotoAlbum> apiAlbumsMap = Map.fromIterable(
        await _albumAPIRepo.getAllAlbums(),
        key: (v) => v.name.toLowerCase(),
        value: (v) => v);
    List<PhotoAlbum> mobileAlbums = await _albumMobileRepo.getAllAlbums();
    mobileAlbums.sort((a, b) => a.name.compareTo(b.name));
    for (PhotoAlbum album in mobileAlbums) {
      if (!apiAlbumsMap.containsKey(album.name.toLowerCase())) {
        PhotoAlbum apiAlbum = await _albumAPIRepo.addAlbum(album);
        apiAlbumsMap[apiAlbum.name] = apiAlbum;
      } else {
        await _albumAPIRepo.removePhotosFromAlbum(album);
        await _albumAPIRepo.addPhotosToAlbum(album, album.photos);
      }
    }
  }

  void dispose() {}
}
