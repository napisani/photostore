import 'dart:typed_data';

abstract class MediaContents {
  const MediaContents();

  factory MediaContents.memory(Uint8List binary) {
    return MediaMemoryContents(binary: binary);
  }

  factory MediaContents.url(String url) {
    return MediaURLContents(url: url);
  }
}

class MediaURLContents extends MediaContents {
  final String url;

  const MediaURLContents({this.url}) : super();
}

class MediaMemoryContents extends MediaContents {
  final Uint8List binary;

  const MediaMemoryContents({this.binary}) : super();
}
