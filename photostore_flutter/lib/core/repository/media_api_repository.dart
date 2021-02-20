import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:photostore_flutter/core/model/media_contents.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/locator.dart';

import 'media_repository.dart';

class MediaAPIRepository extends MediaRepository<Photo> {
  final http.Client httpClient = locator<http.Client>();

  MediaAPIRepository();

  String _getBaseURL() {
    if (this.settings != null) {
      return "${settings.https ? "https" : "http"}://${settings.serverIP}:${settings.serverPort}/api/photos";
    }
    throw new Exception("Server settings are not configured");
  }

  Future<Pagination<Photo>> getPhotosByPage(int page) async {
    print(
        "MediaAPIRepository getPhotosByPage baseUrl: ${_getBaseURL()} page: $page");
    final response = await http.get("${_getBaseURL()}/$page");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      return Pagination<Photo>(
          page: data['page'],
          perPage: data['per_page'],
          total: data['total'],
          items: (data['items'] as List<dynamic>)
              .map((item) => mapResponseToPhoto(item))
              .toList());
    } else {
      final Exception ex = Exception('error fetching photos');
      print("MediaAPIRepository.getPhotosByPage $ex");
      throw ex;
    }
  }

  Future<Photo> getLastBackedUpPhoto() async {
    print("MediaAPIRepository getLastBackedUpPhoto baseUrl: ${_getBaseURL()}");
    final String url = "${_getBaseURL()}/latest";
    final response = await http.get("$url");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return data.containsKey('id')
          ? mapResponseToPhoto(data)
          :
          //no photos currently backed up
          Photo(id: null, creationDate: DateTime.utc(1100, 1, 1));
    } else {
      final Exception ex = Exception('error getting latest backed up photo');
      print("MediaAPIRepository.getLastBackedUpPhoto $ex");
      throw ex;
    }
  }

  Photo mapResponseToPhoto(Map<String, dynamic> item) {
    final String url = "${_getBaseURL()}/thumbnail/${item['id']}";
    return Photo(
        id: item['id'].toString(),
        checksum: item['checksum'],
        gphotoId: item['gphoto_id'],
        filename: item['filename'],
        creationDate: DateTime.parse(item['creation_date']),
        getThumbnailProviderOfSize: (double width, double height) =>
            NetworkImage(url),
        thumbnailProvider: NetworkImage(url),
        thumbnail: Future.value(MediaContents.url(url)),
        mimeType: item['mime_type']);
  }
}
