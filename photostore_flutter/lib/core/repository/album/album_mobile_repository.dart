import 'package:photo_manager/photo_manager.dart';
import 'package:photostore_flutter/core/model/photo_album.dart';
import 'package:photostore_flutter/core/repository/album/album_repository.dart';
import 'package:photostore_flutter/core/repository/mobile_repository_mixin.dart';

class AlbumMobileRepository extends AlbumRepository with MobileRepositoryMixin {
  AlbumMobileRepository({requestPermissions = false}) : super() {
    this.requestPermission();
  }

  @override
  Future<List<PhotoAlbum>> getAllAlbums(
      {Map<String, String> filters}) async {
    List<AssetPathEntity> assetPaths = (await PhotoManager.getAssetPathList(
        onlyAll: false, type: RequestType.all));
    assetPaths.removeWhere((element) => element.isAll);
    return (await Future.wait(assetPaths.map((e) async =>
            PhotoAlbum.fromAssetPath(e, (await e.assetList), this.settings))))
        .toList();
  }
}
