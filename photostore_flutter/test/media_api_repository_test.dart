import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';
import 'package:photostore_flutter/services/media_api_repository.dart';




void main() {
  test('just test calling the photo api', () async {
    final repo = MediaAPIRepository(httpClient: http.Client());
    Pagination<AgnosticMedia> page = await repo.getPhotosByPage(1);
    expect(page, isNotNull);
  });
}
