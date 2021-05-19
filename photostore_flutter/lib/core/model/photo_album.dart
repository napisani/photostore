import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

import 'agnostic_media.dart';
import 'app_settings.dart';
import 'mobile_photo.dart';

class PhotoAlbum extends Equatable {
  final String id;
  final String name;
  final List<AgnosticMedia> photos;
  final isAll;

  const PhotoAlbum({this.id, this.name, this.photos, this.isAll = false});

  factory PhotoAlbum.allOption() => PhotoAlbum(name: "All", isAll: true);

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

  @override
  List<Object> get props => [id, isAll, name];
}
