import 'package:photo_manager/photo_manager.dart';

import 'agnostic_media.dart';
import 'app_settings.dart';
import 'mobile_photo.dart';

class PhotoAlbum {
  final String id;
  final String name;
  final List<AgnosticMedia> photos;

  const PhotoAlbum({
    this.id,
    this.name,
    this.photos,
  });

  factory PhotoAlbum.fromJson(Map<String, dynamic> item) {
    return PhotoAlbum(id: item['id'].toString(), name: item['name']);
  }

  factory PhotoAlbum.fromAssetPath(
      AssetPathEntity ape, List<AssetEntity> assets, AppSettings settings) {
    return PhotoAlbum(
        id: ape.id,
        name: ape.name,
        photos: assets
            .map((e) => MobilePhoto.fromAssetPathEntity(e, settings))
            .toList());
  }

  Map<String, dynamic> toJsonData() {
    return {'name': this.name};
  }
}