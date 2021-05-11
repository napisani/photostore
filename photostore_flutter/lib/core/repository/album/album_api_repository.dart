import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:photostore_flutter/core/repository/album/album_repository.dart';

import '../api_repository_mixin.dart';

class AlbumAPIRepository extends AlbumRepository with APIRepositoryMixin {
  Future<PhotoAlbum> addPhotosToAlbum(
      PhotoAlbum album, List<AgnosticMedia> photos) async {
    print(
        "AlbumAPIRepository addPhotosToAlbum baseUrl: ${getBaseURL(settings)}");
    final response = await httpService.getHttpClient().post(
        "${getBaseURL(settings)}/albums/add_photos_to_album",
        data: photos
            .map((p) => {
                  'name': album.name,
                  'device_id': settings.deviceID,
                  'native_id': p.nativeId
                })
            .toList());
    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      try {
        return mapResponseToPhotoAlbum(data);
      } catch (ex, s) {
        print("AlbumAPIRepository.addPhotosToAlbum - ex: $ex, stack: $s ");
        throw Exception('Failed to parse addPhotosToAlbum response');
      }
    } else {
      final Exception ex =
          Exception('error adding photos to album named: ' + album.name);
      print("AlbumAPIRepository.addPhotosToAlbum $ex");
      throw ex;
    }
  }

  Future<PhotoAlbum> removePhotosFromAlbum(PhotoAlbum album) async {
    print(
        "AlbumAPIRepository removePhotosFromAlbum baseUrl: ${getBaseURL(settings)}");
    final response = await httpService.getHttpClient().delete(
          "${getBaseURL(settings)}/albums/remove_photos_from_album/${urlEncode(album.name)}/${urlEncode(settings.deviceID)}",
        );
    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      try {
        return mapResponseToPhotoAlbum(data);
      } catch (ex, s) {
        print("AlbumAPIRepository.removePhotosFromAlbum - ex: $ex, stack: $s ");
        throw Exception('Failed to parse removePhotosFromAlbum response');
      }
    } else {
      final Exception ex =
          Exception('error removing photos from album named: ' + album.name);
      print("AlbumAPIRepository.removePhotosFromAlbum $ex");
      throw ex;
    }
  }

  Future<PhotoAlbum> addAlbum(PhotoAlbum album) async {
    print("AlbumAPIRepository addAlbum baseUrl: ${getBaseURL(settings)}");
    final response = await httpService.getHttpClient().post(
        "${getBaseURL(settings)}/albums/add_album",
        data: album.toJsonData());
    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      try {
        return mapResponseToPhotoAlbum(data);
      } catch (ex, s) {
        print("AlbumAPIRepository.addAlbum - ex: $ex, stack: $s ");
        throw Exception('Failed to parse getAllAlbums response');
      }
    } else {
      final Exception ex = Exception('error adding album named: ' + album.name);
      print("AlbumAPIRepository.addAlbum $ex");
      throw ex;
    }
  }

  @override
  Future<List<PhotoAlbum>> getAllAlbums({Map<String, String> filters}) async {
    print("AlbumAPIRepository getAllAlbums baseUrl: ${getBaseURL(settings)}");
    final response = await httpService.getHttpClient().get(
        "${getBaseURL(settings)}/albums/get_albums",
        queryParameters: {...(filters != null ? filters : {})});

    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;

      try {
        return data.map((item) => mapResponseToPhotoAlbum(item)).toList();
      } catch (ex, s) {
        print("AlbumAPIRepository.getAllAlbums - ex: $ex, stack: $s ");
        throw Exception('Failed to parse getAllAlbums response');
      }
    } else {
      final Exception ex = Exception('error fetching albums');
      print("AlbumAPIRepository.getAllAlbums $ex");
      throw ex;
    }
  }

  PhotoAlbum mapResponseToPhotoAlbum(Map<String, dynamic> item) =>
      PhotoAlbum.fromJson(item);
}
