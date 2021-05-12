import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:photostore_flutter/core/repository/album/album_mobile_repository.dart';
import 'package:photostore_flutter/locator.dart';

class AlbumMobileService {
  final AlbumMobileRepository _albumMobileRepo =
      locator<AlbumMobileRepository>();

  Future<List<PhotoAlbum>> getAllAlbums({Map<String, String> filters}) async {
    return _albumMobileRepo.getAllAlbums(filters: filters);
  }

  void dispose() {

  }
}
