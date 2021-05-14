import 'package:image_downloader/image_downloader.dart';

import 'abstract_download_service.dart';

class MobileDownloadService extends DownloadService {
  Future<void> downloadImageFile(String url) async {
    try {
      // Saved with this method.
      String imageId = await ImageDownloader.downloadImage(url);
      print('MobileDownloadService downloadImageFile imageId: $imageId');
      // // Below is a method of obtaining saved image information.
      // var fileName = await ImageDownloader.findName(imageId);
      // var path = await ImageDownloader.findPath(imageId);
      // var size = await ImageDownloader.findByteSize(imageId);
      // var mimeType = await ImageDownloader.findMimeType(imageId);
    } catch (error, s) {
      print('error downloadingFile: $error - $s ');
    }
  }
}


DownloadService getDownloadService() => MobileDownloadService();
