import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';
import 'package:photostore_flutter/services/photo_page_repository.dart';

class PhotoPageAPIRepository extends PhotoPageRepository {
  final String baseUrl = "http://192.168.1.134:5000/api/photos";
  final http.Client httpClient;

  PhotoPageAPIRepository({this.httpClient}) : super();

  Future<Pagination<Photo>> getPhotosByPage(int page) async {
    final response = await http.get(baseUrl + "/$page");
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      print(data);
      return Pagination<Photo>(
          page: data['page'],
          perPage: data['per_page'],
          remainingPages: 2,
          total: data['total'],
          items: (data['items'] as List<dynamic>).map((item) {
            return Photo(
                id: item['id'],
                checksum: item['checksum'],
                gphotoId: item['gphoto_id'],
                filename: item['filename'],
                creationDate: null,
                mimeType: item['mime_type']);
          }).toList());
    } else {
      throw Exception('error fetching photos');
    }
  }
}
