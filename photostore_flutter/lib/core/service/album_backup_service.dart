import 'package:photostore_flutter/core/model/cancel_notifier.dart';
import 'package:photostore_flutter/core/model/pause_notifier.dart';
import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:photostore_flutter/core/model/progress_log.dart';
import 'package:photostore_flutter/core/service/album/album_api_service.dart';
import 'package:photostore_flutter/core/service/album/album_mobile_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'backup_services.dart';

class AlbumBackupService {
  final AlbumAPIService _albumAPIService = locator<AlbumAPIService>();
  final AlbumMobileService _albumMobileService =
      locator<AlbumMobileService>();

  ProgressStats _buildProgressStatForAlbum(PhotoAlbum album) {
    ProgressStats stats = ProgressStats(
        id: "Album: ${album.name}",
        status: "Backup in Progress...",
        details:
            "Currently backing up Album named: ${album.name} at ${DateTime.now()}");
    return stats;
  }

  ProgressStats _buildProgressStatsForComparing() {
    ProgressStats stats = ProgressStats(
        id: "Comparing Albums",
        status: "In Progress...",
        details: "Currently comparing Albums at ${DateTime.now()}");
    return stats;
  }

  Future<void> doAlbumBackup(
      {BackupProgressHandler progressNotify,
      CancelNotifier canceller,
      PauseNotifier pauseNotifier,
      ProgressLog progressLog}) async {
    if (canceller != null && canceller.hasBeenCancelled) {
      print('cancelled doAlbumBackup');
      return;
    }
    while (pauseNotifier != null && pauseNotifier.hasBeenPaused) {
      print('album backup paused sleeping for 2 seconds...');
      await new Future.delayed(const Duration(seconds: 2));
    }
    ProgressStats comparingAlbumProgressStats =
        _buildProgressStatsForComparing();
    progressLog?.add(comparingAlbumProgressStats);
    Map<String, PhotoAlbum> apiAlbumsMap;
    try {
      apiAlbumsMap = Map.fromIterable(await _albumAPIService.getAllAlbums(),
          key: (v) => v.name.toLowerCase(), value: (v) => v);
    } catch (ex, s) {
      print('Error getting Alums from API  $ex, Stack: $s');
      comparingAlbumProgressStats.updateStatus("ERROR",
          details:
              "An error occurred getting albums from the server - error: $ex");
      return;
    }
    List<PhotoAlbum> mobileAlbums;
    try {
      mobileAlbums = await _albumMobileService.getAllAlbums();
    } catch (ex, s) {
      print('Error getting Alums from mobile phone  $ex, Stack: $s');
      comparingAlbumProgressStats.updateStatus("ERROR",
          details:
              "An error occurred getting albums from mobile device - error: $ex");
      return;
    }
    comparingAlbumProgressStats.updateStatus("DONE",
        details: "Finished comparing albums at ${DateTime.now()}");
    mobileAlbums.sort((a, b) => a.name.compareTo(b.name));
    for (PhotoAlbum album in mobileAlbums) {
      if (canceller != null && canceller.hasBeenCancelled) {
        print('cancelled doAlbumBackup');
        return;
      }
      while (pauseNotifier != null && pauseNotifier.hasBeenPaused) {
        print('album backup paused sleeping for 2 seconds...');
        await new Future.delayed(const Duration(seconds: 2));
      }
      ProgressStats albumStats = _buildProgressStatForAlbum(album);
      progressLog?.add(albumStats);
      try {
        if (!apiAlbumsMap.containsKey(album.name.toLowerCase())) {
          PhotoAlbum apiAlbum = await _albumAPIService.addAlbum(album);
          apiAlbumsMap[apiAlbum.name] = apiAlbum;
        } else {
          await _albumAPIService.removePhotosFromAlbum(album);
        }
        await _albumAPIService.addPhotosToAlbum(album, album.photos);


        albumStats.updateStatus("DONE",
            details:
                "Finished backing up Album named: ${album.name} at ${DateTime.now()}");
      } catch (ex, s) {
        print('Error backing up album $ex, Stack: $s');
        albumStats.updateStatus("ERROR",
            details:
                "An error occurred backing up album named: ${album.name} - error: $ex");
      }
    }
  }

  void dispose() {}
}
