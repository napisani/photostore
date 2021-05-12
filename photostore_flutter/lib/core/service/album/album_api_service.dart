import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:photostore_flutter/core/repository/album/album_api_repository.dart';
import 'package:photostore_flutter/locator.dart';

class AlbumAPIService {
  final AlbumAPIRepository _albumAPIRepo = locator<AlbumAPIRepository>();

  Future<PhotoAlbum> addPhotosToAlbum(
      PhotoAlbum album, List<AgnosticMedia> photos) async {
    return await _albumAPIRepo.addPhotosToAlbum(album, photos);
  }

  Future<PhotoAlbum> removePhotosFromAlbum(PhotoAlbum album) async {
    return await _albumAPIRepo.removePhotosFromAlbum(album);
  }

  Future<PhotoAlbum> addAlbum(PhotoAlbum album) async {
    return await _albumAPIRepo.addAlbum(album);
  }

  Future<List<PhotoAlbum>> getAllAlbums({Map<String, String> filters}) async {
    return await _albumAPIRepo.getAllAlbums(filters: filters);
  }

  void dispose() {}
}
