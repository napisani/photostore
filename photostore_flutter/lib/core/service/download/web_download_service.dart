import 'dart:html' as html;

import 'package:photostore_flutter/core/service/download/abstract_download_service.dart';

class WebDownloadService extends DownloadService {
  Future<void> downloadImageFile(String url) async {
    html.AnchorElement anchorElement = new html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }
}

DownloadService getDownloadService() => WebDownloadService();
