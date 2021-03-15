import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:photostore_flutter/core/model/media_contents.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/locator.dart';

import 'media_repository.dart';

class MediaAPIRepository extends MediaRepository<Photo> {
  final http.Client httpClient = locator<http.Client>();

  MediaAPIRepository();

  String _getBaseURL() {
    if (this.settings != null) {
      return "${settings.https ? "https" : "http"}://${settings.serverIP}:${settings.serverPort}/api/v1/photos";
    }
    throw new Exception("Server settings are not configured");
  }

  Future<Photo> uploadPhoto(MobilePhoto photo) async {
    print(
        "MediaAPIRepository uploadPhoto baseUrl: ${_getBaseURL()} photo: $photo");
    var request =
        new http.MultipartRequest("POST", Uri.parse('${_getBaseURL()}/upload'));
    // request.fields['metadata'] = jsonEncode({'id': photo.id});
    final MultipartFile metadata = MultipartFile.fromString(
        'metadata', jsonEncode({'id': 0, 'thumbnail_path': ''}),
        filename: "metadata");

    final MultipartFile file = await MultipartFile.fromPath(
        'file', (await photo.originFile).path,
        filename: 'file');
    request.files.add(metadata);
    request.files.add(file);

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
    return null;
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
        width: item['width'],
        height: item['height'],
        longitude: item['longitude'],
        latitude: item['latitude'],
        nativeId: item['native_id'],
        deviceId: item['device_id'],
        creationDate: DateTime.parse(item['creation_date']),
        modifiedDate: DateTime.parse(item['modified_date']),
        getThumbnailProviderOfSize: (double width, double height) =>
            NetworkImage(url),
        thumbnailProvider: NetworkImage(url),
        thumbnail: Future.value(MediaContents.url(url)),
        mimeType: item['mime_type']);
  }
}
