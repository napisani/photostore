import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/media_contents.dart';
import 'package:photostore_flutter/models/pagination.dart';

abstract class MediaRepository<T extends AgnosticMedia>{
  Future<Pagination<T>> getPhotosByPage(int page);


}
