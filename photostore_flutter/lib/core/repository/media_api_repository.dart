import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/core/model/photo_diff_request.dart';
import 'package:photostore_flutter/core/model/photo_diff_result.dart';
import 'package:photostore_flutter/core/service/http_service.dart';
import 'package:photostore_flutter/locator.dart';

import 'media_repository.dart';

class MediaAPIRepository extends MediaRepository<Photo> {
  final HTTPService _httpService = locator<HTTPService>();


  String _getBaseURL() {
    if (this.settings != null) {
      return "${settings.https ? "https" : "http"}://${settings.serverIP}:${settings.serverPort}/api/v1/photos";
    }
    throw new Exception("Server settings are not configured");
  }

  Future<Photo> uploadPhoto(MobilePhoto photo) async {
    print(
        "MediaAPIRepository uploadPhoto baseUrl: ${_getBaseURL()} photo: $photo");

    final Map<String, dynamic> jsonData = photo.toJson();
    jsonData['device_id'] = settings.deviceID;
    final File originFile = (await photo.getOriginFile());
    jsonData['filename'] = originFile.path;
    FormData formData = FormData.fromMap({
      "metadata":
          MultipartFile.fromString(jsonEncode(jsonData), filename: "metadata"),
      "file": MultipartFile.fromFileSync(originFile.path,
          filename: originFile.path),
    });
    Response res = await _httpService
        .getHttpClient()
        .post('${_getBaseURL()}/upload', data: formData);
    // final Map<String, dynamic> data = json.decode(response.body);
    // print(data);
    return null;
  }

  Future<Pagination<Photo>> getPhotosByPage(int page) async {
    print(
        "MediaAPIRepository getPhotosByPage baseUrl: ${_getBaseURL()} page: $page");
    final response =
        await _httpService.getHttpClient().get("${_getBaseURL()}/$page");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;
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
    final String url = "${_getBaseURL()}/latest/${settings.deviceID}";
    final response = await _httpService.getHttpClient().get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

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
    final String url = "${_getBaseURL()}/count/${settings.deviceID}";
    final response = await _httpService.getHttpClient().get(url);
    if (response.statusCode == 200) {
      return response.data;
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

    final response = await _httpService
        .getHttpClient()
        .post(url, data: json.encoder.convert(reqs));
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map<PhotoDiffResult>(
              (jsonData) => PhotoDiffResult.fromJson(jsonData))
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
