import 'package:photo_gallery/photo_gallery.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';

class MediaMobileRepository {
  Future<List<Album>> getPhotoAlbums() async {
    final List<Album> imageAlbums = await PhotoGallery.listAlbums(
      mediumType: MediumType.image,
    );
    return imageAlbums;
  }

  Future<Pagination<Photo>> getPhotosByPageAndAlbum(int page) async {}
}
