import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:photostore_flutter/core/model/media_device.dart';
import 'package:photostore_flutter/core/model/mobile_photo.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/core/model/photo.dart';
import 'package:photostore_flutter/core/model/photo_date_ranges.dart';
import 'package:photostore_flutter/core/model/photo_diff_request.dart';
import 'package:photostore_flutter/core/model/photo_diff_result.dart';
import 'package:photostore_flutter/core/utils/api_key_utils.dart';

import '../api_repository_mixin.dart';
import 'media_repository.dart';

class MediaAPIRepository extends MediaRepository<Photo>
    with APIRepositoryMixin {
  Future<void> deletePhotosByDeviceID({String deviceId}) async {

    if (deviceId == null || deviceId == '') {
      deviceId = settings.deviceID;
    }
    deviceId = Uri.encodeFull(deviceId);
    print(
        "MediaAPIRepository deletePhotosByDeviceID baseUrl: ${getBaseURL(settings)} ");
    final response = await httpService
        .getHttpClient()
        .delete("${getBaseURL(settings)}/photos/delete_by_device/$deviceId");
    checkForCorrectAuth(response);
    if (response.statusCode != 200) {
      final Exception ex = Exception('error deleting photos by device id');
      print("MediaAPIRepository.deletePhotosByDeviceID $ex");
      throw ex;
    }
  }

  Future<void> deletePhoto({String id}) async {
    id = Uri.encodeFull(id);
    print("MediaAPIRepository deletePhoto baseUrl: ${getBaseURL(settings)} ");
    final response = await httpService
        .getHttpClient()
        .delete("${getBaseURL(settings)}/photos/delete_by_id/$id");
    checkForCorrectAuth(response);
    if (response.statusCode != 200) {
      final Exception ex = Exception('error deleting photos by photo id');
      print("MediaAPIRepository.deletePhoto $ex");
      throw ex;
    }
  }

  Future<Photo> uploadPhoto(MobilePhoto photo) async {
    print(
        "MediaAPIRepository uploadPhoto baseUrl: ${getBaseURL(settings)} photo: $photo");
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
    Response res = await httpService
        .getHttpClient()
        .post('${getBaseURL(settings)}/photos/upload', data: formData);
    // final Map<String, dynamic> data = json.decode(response.body);
    // print(data);
    return null;
  }

  Future<Pagination<Photo>> getPhotosByPage(int page,
      {Map<String, String> filters}) async {
    print(
        "MediaAPIRepository getPhotosByPage baseUrl: ${getBaseURL(settings)} page: $page");
    final response = await httpService
        .getHttpClient()
        .get("${getBaseURL(settings)}/photos/page/$page", queryParameters: {
      "per_page": itemsPerPage,
      "sort": "modified_date",
      "direction": "desc",
      ...(filters != null ? filters : {})
    });

    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      try {
        return Pagination<Photo>(
            page: data['page'],
            perPage: data['per_page'],
            total: data['total'],
            items: (data['items'] as List<dynamic>)
                .map((item) => mapResponseToPhoto(item))
                .toList());
      } catch (ex, s) {
        print("MediaAPIRepository.getPhotosByPage - ex: $ex, stack: $s ");
        throw Exception('Failed to parse getPhotosByPage response');
      }
    } else {
      final Exception ex = Exception('error fetching photos');
      print("MediaAPIRepository.getPhotosByPage $ex");
      throw ex;
    }
  }

  Future<Photo> getLastBackedUpPhoto() async {
    print(
        "MediaAPIRepository getLastBackedUpPhoto baseUrl: ${getBaseURL(settings)}");
    final String url =
        "${getBaseURL(settings)}/photos/latest/${urlEncode(settings.deviceID)}";
    final response = await httpService.getHttpClient().get(url);
    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

      try {
        return data != null && data.containsKey('id')
            ? mapResponseToPhoto(data)
            :
            //no photos currently backed up
            Photo(id: null, creationDate: DateTime.utc(1100, 1, 1));
      } catch (ex, s) {
        print("MediaAPIRepository.getLastBackedUpPhoto - ex: $ex, stack: $s ");
        throw Exception('Failed to parse getLastBackedUpPhoto response');
      }
    } else {
      final Exception ex = Exception('error getting latest backed up photo');
      print("MediaAPIRepository.getLastBackedUpPhoto $ex");
      throw ex;
    }
  }

  Future<int> getPhotoCount() async {
    print("MediaAPIRepository getPhotoCount baseUrl: ${getBaseURL(settings)}");
    final String url =
        "${getBaseURL(settings)}/photos/count/${urlEncode(settings.deviceID)}";
    final response = await httpService.getHttpClient().get(url);
    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      final Exception ex = Exception('error getting photo count from server');
      print("MediaAPIRepository.getPhotoCount $ex");
      throw ex;
    }
  }

  Future<PhotoDateRanges> getPhotoDateRanges() async {
    print(
        "MediaAPIRepository getPhotoDateRanges baseUrl: ${getBaseURL(settings)}");
    final String url = "${getBaseURL(settings)}/photos/dates";
    final response = await httpService.getHttpClient().get(url);
    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      return PhotoDateRanges.fromJson(response.data);
    } else {
      final Exception ex =
          Exception('error getting photo date ranges from server');
      print("MediaAPIRepository.getPhotoDateRanges $ex");
      throw ex;
    }
  }

  Future<List<MediaDevice>> getDevices() async {
    print("MediaAPIRepository getDevices baseUrl: ${getBaseURL(settings)}");
    final String url = "${getBaseURL(settings)}/photos/devices";

    final response = await httpService.getHttpClient().get(url);
    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      try {
        return data
            .map<MediaDevice>((jsonData) => MediaDevice.fromJson(jsonData))
            .toList();
      } catch (ex, s) {
        print("MediaAPIRepository.getDevices - ex: $ex, stack: $s ");
        throw Exception('Failed to parse getDevices response');
      }
    } else {
      final Exception ex = Exception(
          'error getting the list of media devices from the server statusCode: ${response.statusCode}, message: ${response.statusMessage}');
      print(
          "MediaAPIRepository.getDevices - statusCode: ${response.statusCode}, message: ${response.statusMessage}");
      throw ex;
    }
  }

  Future<List<PhotoDiffResult>> diffPhotos(
      List<PhotoDiffRequest> photoDiffReqs) async {
    print("MediaAPIRepository diffPhotos baseUrl: ${getBaseURL(settings)}");
    final String url = "${getBaseURL(settings)}/photos/diff";
    final List<Map<String, dynamic>> reqs =
        photoDiffReqs.map<Map<String, dynamic>>((req) => req.toJson()).toList();

    final response = await httpService
        .getHttpClient()
        .post(url, data: json.encoder.convert(reqs));
    checkForCorrectAuth(response);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;

      try {
        return data
            .map<PhotoDiffResult>(
                (jsonData) => PhotoDiffResult.fromJson(jsonData))
            .toList();
      } catch (ex, s) {
        print("MediaAPIRepository.diffPhotos - ex: $ex, stack: $s ");
        throw Exception('Failed to parse diffPhotos response');
      }
    } else {
      final Exception ex = Exception(
          'error getting photo differences between the mobile device and the server');
      print("MediaAPIRepository.diffPhotos $ex");
      throw ex;
    }
  }

  Photo mapResponseToPhoto(Map<String, dynamic> item) {
    final String thumbnailUrl =
        "${getBaseURL(settings)}/photos/thumbnail/${item['id']}";
    final String fullSizeAsPngUrl =
        "${getBaseURL(settings)}/photos/fullsize_photo_as_png/${item['id']}";
    final String fullSizeUrl =
        "${getBaseURL(settings)}/photos/fullsize_photo/${item['id']}";

    return Photo.fromJson(item, thumbnailUrl, fullSizeUrl, fullSizeAsPngUrl,
        {ACCESS_TOKEN_KEY: settings.apiKey});
  }

  String getOriginalFileURL(String photoId, {bool withAPIKey = false}) =>
      _getPhotoUrl(photoId, 'original_file', withAPIKey: withAPIKey);

  String getFullsizePNGURL(String photoId, {bool withAPIKey = false}) =>
      _getPhotoUrl(photoId, 'fullsize_photo_as_png', withAPIKey: withAPIKey);

  String getThumbnailURL(String photoId, {bool withAPIKey = false}) =>
      _getPhotoUrl(photoId, 'thumbnail', withAPIKey: withAPIKey);

  String _getPhotoUrl(String photoId, String subpath,
      {bool withAPIKey = false}) {
    String url =
        "${getBaseURL(settings)}/photos/$subpath/${urlEncode(photoId)}";
    return withAPIKey
        ? APIKeyUtils.appendAPIKeyToURL(
            url, {ACCESS_TOKEN_KEY: settings.apiKey})
        : url;
  }
}
