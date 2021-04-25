import 'package:photo_manager/photo_manager.dart';
import 'package:photostore_flutter/core/model/future_memory_image.dart';
import 'package:photostore_flutter/core/model/media_contents.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/pagination.dart';

import 'media_repository.dart';

class MediaMobileRepositoryV2 extends MediaRepository<MobilePhoto> {
  AssetPathEntity _allPath;

  MediaMobileRepositoryV2({requestPermissions = true}) : super() {
    this.requestPermission();
  }

  Future<bool> requestPermission({openSettings = true}) async {
    bool result = await PhotoManager.requestPermission();
    if (!result && openSettings) {
      PhotoManager.openSetting();
    }
    return result;
  }

  Future<AssetPathEntity> getAllAlbum({includeVideos = true}) async {
    if (this._allPath == null) {
      this._allPath = (await PhotoManager.getAssetPathList(
              onlyAll: true,
              type: includeVideos ? RequestType.all : RequestType.image))
          .first;
    }
    return this._allPath;
  }

  Future<int> getPhotoCount() async {
    AssetPathEntity allAlbum = await this.getAllAlbum();
    return allAlbum.assetCount;
  }

  Future<Pagination<MobilePhoto>> getPhotosByPage(int page, {Map<String, String> filters}) async {
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
            .map((item) => MobilePhoto(
                id: item.id,
                checksum: '',
                gphotoId: '',
                assetType: item.typeInt,
                filename: item.title,
                creationDate: item.createDateTime,
                modifiedDate: item.modifiedDateTime,
                width: item.width,
                height: item.height,
                longitude: item.longitude,
                latitude: item.latitude,
                nativeId: item.id,
                deviceId: settings.deviceID,
                // originFile: ()=> item.loadFile(isOrigin: false),
                getOriginFile: () => item.originFile,
                getThumbnailProviderOfSize: (double width, double height) =>
                    FutureMemoryImage(() => item
                        .thumbDataWithSize(width.round(), height.round())
                        .asStream()
                        .first),
                thumbnailProvider:
                    FutureMemoryImage(() => item.thumbData.asStream().first),
                getThumbnail: () => item.thumbData
                    .asStream()
                    .map((bin) => MediaContents.memory(bin))
                    .first,
                mimeType: ''))
            .toList());
    //.getMedium(
    //mediumId: this._allAlbum.id, mediumType: MediumType.image);
  }
}
