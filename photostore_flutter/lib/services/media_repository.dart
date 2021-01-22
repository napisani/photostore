import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/app_settings.dart';
import 'package:photostore_flutter/models/media_contents.dart';
import 'package:photostore_flutter/models/pagination.dart';

abstract class MediaRepository<T extends AgnosticMedia>{
  AppSettings settings;


  Future<Pagination<T>> getPhotosByPage(int page);
  void setAppSettings(AppSettings settings) {
    this.settings = settings;
  }

}
