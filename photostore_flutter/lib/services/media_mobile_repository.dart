import 'package:photo_gallery/photo_gallery.dart';
import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/mobile_photo.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';

import 'media_repository.dart';

const int _ITEMS_PER_AGE = 10;

class MediaMobileRepository extends MediaRepository<Photo> {
  Album _allAlbum;

  Future<List<Album>> getPhotoAlbums() async {
    final List<Album> imageAlbums = await PhotoGallery.listAlbums(
      mediumType: MediumType.image,
    );
    return imageAlbums;
  }

  Future<Pagination<AgnosticMedia>> getPhotosByPageAndAlbum(int page) async {}

  Future<Pagination<Photo>> getPhotosByPage(int page) async {
    if (this._allAlbum == null) {
      this._allAlbum =
          (await this.getPhotoAlbums()).firstWhere((album) => album.isAllAlbum);
    }
    final int skip = _ITEMS_PER_AGE * (page - 1);
    final MediaPage mediaPage =
        await _allAlbum.listMedia(skip: skip, take: _ITEMS_PER_AGE);
    return Pagination<Photo>(
        page: page,
        perPage: _ITEMS_PER_AGE,
        total: mediaPage.total,
        items: mediaPage.items.map((item) {
          return Photo(
              id: item.id,
              checksum: '',
              gphotoId: '',
              filename: '',
              creationDate: item.creationDate,
              mimeType: '');
        }).toList());
    //.getMedium(
    //mediumId: this._allAlbum.id, mediumType: MediumType.image);
  }
}
