import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:photostore_flutter/models/app_settings.dart';
import 'package:photostore_flutter/models/media_contents.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';
import 'package:photostore_flutter/services/media_repository.dart';

class MediaAPIRepository extends MediaRepository<Photo> {
  final http.Client httpClient;

  MediaAPIRepository({@required this.httpClient}) : super();

  String _getBaseURL() {
    if (this.settings != null) {
      return "${settings.https ? "https" : "http"}://${settings.serverIP}:${settings.serverPort}/api/photos";
    }
    throw new Exception("Server settings are not configured");
  }



  Future<Pagination<Photo>> getPhotosByPage(int page) async {
    print("MediaAPIRepository getPhotosByPage baseUrl: ${_getBaseURL()} page: $page");
    final response = await http.get("${_getBaseURL()}/$page");
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      print(data);
      return Pagination<Photo>(
          page: data['page'],
          perPage: data['per_page'],
          total: data['total'],
          items: (data['items'] as List<dynamic>).map((item) {
            return Photo(
                id: item['id'].toString(),
                checksum: item['checksum'],
                gphotoId: item['gphoto_id'],
                filename: item['filename'],
                creationDate: null,
                thumbnail: Future.value(
                    MediaContents.url("${_getBaseURL()}/thumbnail/${item['id']}")),
                mimeType: item['mime_type']);
          }).toList());
    } else {
      final Exception ex = Exception('error fetching photos');
      print("MediaAPIRepository.getPhotosByPage $ex");
      throw ex;
    }
  }
}
