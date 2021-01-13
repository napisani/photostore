import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';
import 'package:photostore_flutter/services/photo_page_api_repository.dart';

void main() {
  test('value should start at 0', () async {
    final repo = PhotoPageAPIRepository(httpClient: http.Client());
    Pagination<Photo> page = await repo.getPhotosByPage(1);
    expect(page, isNotNull);
  });
}
