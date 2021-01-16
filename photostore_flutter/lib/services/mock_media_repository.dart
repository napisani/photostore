import 'dart:math';

import 'package:photostore_flutter/models/media_contents.dart';
import 'package:photostore_flutter/models/pagination.dart';
import 'package:photostore_flutter/models/photo.dart';
import 'package:photostore_flutter/services/media_repository.dart';

class MockMediaRepository extends MediaRepository<Photo> {
  String _randString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  Iterable<Photo> _generatePhoto() sync* {
    int i = 0;
    for (;;) {
      yield Photo(
          mimeType: "image/png",
          creationDate: DateTime.now(),
          filename: _randString(5) + ".png",
          gphotoId: _randString(7),
          checksum: _randString(16),
          thumbnail: Future.value(MediaContents.url(
              "https://upload.wikimedia.org/wikipedia/en/9/95/Test_image.jpg")),
          id: i.toString());
      i++;
    }
  }

  Iterable<Pagination<Photo>> _generatePage(int total) sync* {
    int page = 1;
    final perPage = 10;
    final photoGen = _generatePhoto().iterator;
    for (;;) {
      final frame = Pagination<Photo>(
          perPage: perPage,
          page: page,
          items: Iterable<int>.generate(10).toList().map((e) {
            photoGen.moveNext();
            return photoGen.current;
          }).toList(),
          total: total);
      yield frame;
      if (frame.page * frame.perPage >= frame.total) {
        throw Exception("total photos exceeded!");
      }
      page++;
    }
  }

  Iterator<Pagination<Photo>> pageGen;
  final simulatedWait;

  MockMediaRepository({this.simulatedWait = 0}) {
    this.pageGen = _generatePage(200).iterator;
  }

  @override
  Future<Pagination<Photo>> getPhotosByPage(int page) async {
    this.pageGen.moveNext();
    Pagination<Photo> page = this.pageGen.current;
    // sleep(Duration(seconds: simulatedWait));
    return Future.delayed(Duration(seconds: simulatedWait), () => page);
  }

  Future<MediaContents> getThumbnail(Photo media) async {
    return MediaContents.url(
        "https://upload.wikimedia.org/wikipedia/en/9/95/Test_image.jpg");
  }
}
