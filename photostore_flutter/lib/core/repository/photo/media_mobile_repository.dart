import 'package:photo_manager/photo_manager.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/repository/mobile_repository_mixin.dart';

import 'media_repository.dart';

class MediaMobileRepository extends MediaRepository<MobilePhoto>
    with MobileRepositoryMixin {
  AssetPathEntity _allPath;

  MediaMobileRepository({requestPermissions = true}) : super() {
    this.requestPermission();
  }



  Future<AssetPathEntity> getAllAlbum({includeVideos = true}) async {
    await ensurePermissionGranted();
    if (this._allPath == null) {
      this._allPath = (await PhotoManager.getAssetPathList(
              onlyAll: true,
              type: includeVideos ? RequestType.all : RequestType.image))
          .first;
    }
    return this._allPath;
  }

  Future<int> getPhotoCount() async {
    await ensurePermissionGranted();
    AssetPathEntity allAlbum = await this.getAllAlbum();
    return allAlbum.assetCount;
  }

  Future<Pagination<MobilePhoto>> getPhotosByPage(int page,
      {Map<String, String> filters}) async {
    await ensurePermissionGranted();
    AssetPathEntity allAlbum = await this.getAllAlbum();
    int perPageOrRemaining = allAlbum.assetCount - ((page - 1) * itemsPerPage);
    if (perPageOrRemaining > itemsPerPage) {
      perPageOrRemaining = itemsPerPage;
    }
    final int skip = itemsPerPage * (page - 1);
    List<AssetEntity> assets = await allAlbum.getAssetListRange(
        start: skip, end: skip + perPageOrRemaining);
    print(
        'getPhotosByPage allAlbum : $allAlbum assets: ${assets.length} , itemsPerPage: $itemsPerPage');
    return Pagination<MobilePhoto>(
        page: page,
        perPage: itemsPerPage,
        total: allAlbum.assetCount,
        items: assets
            .map((item) => MobilePhoto.fromAssetPathEntity(item, settings))
            .toList());
    //.getMedium(
    //mediumId: this._allAlbum.id, mediumType: MediumType.image);
  }
}
