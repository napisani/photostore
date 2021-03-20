import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/core/model/photo_diff_request.dart';
import 'package:photostore_flutter/core/model/photo_diff_result.dart';
import 'package:photostore_flutter/locator.dart';

import 'media_repository.dart';

class MediaAPIRepository extends MediaRepository<Photo> {
  final http.Client httpClient = locator<http.Client>();
  final String deviceId = "test_iphone";

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
    final Map<String, dynamic> jsonData = photo.toJson();
    jsonData['device_id'] = deviceId;
    final String path = (await photo.originFile).path;
    jsonData['filename'] = path;
    final MultipartFile metadata = MultipartFile.fromString(
        'metadata', jsonEncode(jsonData),
        filename: "metadata");
    final MultipartFile file =
        await MultipartFile.fromPath('file', path, filename: photo.filename);
    request.files.add(metadata);
    request.files.add(file);

    // request.send().then((response) {
    //   if (response.statusCode == 200) print("Uploaded!");
    // });
    final StreamedResponse resp = await request.send();
    // final Map<String, dynamic> data = json.decode(response.body);
    // print(data);
    return null;
  }

  Future<Pagination<Photo>> getPhotosByPage(int page) async {
    print(
        "MediaAPIRepository getPhotosByPage baseUrl: ${_getBaseURL()} page: $page");
    final response = await http.get(Uri.parse("${_getBaseURL()}/$page"));
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
    final String url = "${_getBaseURL()}/latest/$deviceId";
    final response = await http.get(Uri.parse("$url"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return data != null && data.containsKey('id')
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

  Future<int> getPhotoCount() async {
    print("MediaAPIRepository getPhotoCount baseUrl: ${_getBaseURL()}");
    final String url = "${_getBaseURL()}/count/$deviceId";
    final response = await http.get(Uri.parse("$url"));
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      final Exception ex = Exception('error getting photo count from server');
      print("MediaAPIRepository.getPhotoCount $ex");
      throw ex;
    }
  }

  Future<List<PhotoDiffResult>> diffPhotos(
      List<PhotoDiffRequest> photoDiffReqs) async {
    print("MediaAPIRepository diffPhotos baseUrl: ${_getBaseURL()}");
    final String url = "${_getBaseURL()}/diff";
    final List<Map<String, dynamic>> reqs =
        photoDiffReqs.map<Map<String, dynamic>>((req) => req.toJson()).toList();

    final response = await http.post(Uri.parse("$url"), body: json.encoder.convert(reqs));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map<PhotoDiffResult>((jsonData) => PhotoDiffResult.fromJson(jsonData))
          .toList();
    } else {
      final Exception ex = Exception(
          'error getting photo differences between the mobile device and the server');
      print("MediaAPIRepository.diffPhotos $ex");
      throw ex;
    }
  }

  Photo mapResponseToPhoto(Map<String, dynamic> item) {
    final String url = "${_getBaseURL()}/thumbnail/${item['id']}";
    return Photo.fromJson(item, url);
  }
}
