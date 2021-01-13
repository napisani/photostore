import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';

abstract class PhotoPageRepository {
  Future<Pagination<Photo>> getPhotosByPage(int page);
}
