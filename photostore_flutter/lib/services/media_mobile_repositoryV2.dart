import 'package:photo_manager/photo_manager.dart';
import 'package:photostore_flutter/models/future_memory_image.dart';
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
      this._allPath = (await PhotoManager.getAssetPathList(
          onlyAll: true, type: RequestType.image))
          .first;
    }
    return this._allPath;
  }

  Future<Pagination<MobilePhoto>> getPhotosByPage(int page) async {
    AssetPathEntity allAlbum = await this.getAllAlbum();
    int perPageOrRemaining =
        allAlbum.assetCount - ((page - 1) * _ITEMS_PER_AGE);
    if (perPageOrRemaining > _ITEMS_PER_AGE) {
      perPageOrRemaining = _ITEMS_PER_AGE;
    }
    final int skip = _ITEMS_PER_AGE * (page - 1);
    List<AssetEntity> assets = await allAlbum.getAssetListRange(
        start: skip, end: skip + perPageOrRemaining);
    print('getPhotosByPage allAlbum : $allAlbum assets: ${assets.length}');
    return Pagination<MobilePhoto>(
        page: page,
        perPage: _ITEMS_PER_AGE,
        total: allAlbum.assetCount,
        items: assets
            .map((item) =>
            MobilePhoto(
                id: item.id,
                checksum: '',
                gphotoId: '',
                filename: item.title,
                creationDate: item.createDateTime,
                getThumbnailProviderOfSize: (double width, double height) =>
                    FutureMemoryImage(item
                        .thumbDataWithSize(width.round(), height.round())
                        .asStream()
                        .first),
                thumbnailProvider: FutureMemoryImage(item.thumbData
                    .asStream()
                    .first),
                thumbnail: item.thumbData
                    .asStream()
                    .map((bin) => MediaContents.memory(bin))
                    .first,
                mimeType: ''))
            .toList());
    //.getMedium(
    //mediumId: this._allAlbum.id, mediumType: MediumType.image);
  }
}
