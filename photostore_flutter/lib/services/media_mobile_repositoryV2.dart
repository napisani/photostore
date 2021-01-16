import 'package:photo_manager/photo_manager.dart';
import 'package:photostore_flutter/models/media_contents.dart';
import 'package:photostore_flutter/models/mobile_photo.dart';
import 'package:photostore_flutter/models/pagination.dart';

import 'media_repository.dart';

const int _ITEMS_PER_AGE = 10;

class MediaMobileRepositoryV2 extends MediaRepository<MobilePhoto> {
  AssetPathEntity _allPath;

  MediaMobileRepositoryV2({requestPermissions = true}) {
    this.requestPermission();
  }

  Future<bool> requestPermission({openSettings = true}) async {
    bool result = await PhotoManager.requestPermission();
    if (!result && openSettings) {
      PhotoManager.openSetting();
    }
    return result;
  }

  Future<AssetPathEntity> getAllAlbum() async {
    if (this._allPath == null) {
      this._allPath = (await PhotoManager.getAssetPathList(hasAll: true)).first;
    }
    return this._allPath;
  }

  Future<Pagination<MobilePhoto>> getPhotosByPage(int page) async {
    AssetPathEntity allAlbum = await this.getAllAlbum();
    List<AssetEntity> assets =
        await allAlbum.getAssetListPaged(page, _ITEMS_PER_AGE);

    return Pagination<MobilePhoto>(
        page: page,
        perPage: _ITEMS_PER_AGE,
        total: allAlbum.assetCount,
        items: assets.map((item) {
          return MobilePhoto(
              id: item.id,
              checksum: '',
              gphotoId: '',
              filename: item.title,
              creationDate: item.createDateTime,
              thumbnail: item.thumbData
                  .asStream()
                  .map((bin) => MediaContents.memory(bin))
                  .first,
              mimeType: '');
        }).toList());
    //.getMedium(
    //mediumId: this._allAlbum.id, mediumType: MediumType.image);
  }
}
