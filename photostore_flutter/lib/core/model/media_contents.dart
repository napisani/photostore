import 'dart:typed_data';

abstract class MediaContents {
  const MediaContents();

  factory MediaContents.memory(Uint8List binary) {
    return MediaMemoryContents(binary: binary);
  }

  factory MediaContents.url(String url, {Map<String, String> headers}) {
    return MediaURLContents(url: url, headers: headers);
  }
}

class MediaURLContents extends MediaContents {
  final String url;
  final Map<String, String> headers;

  const MediaURLContents({this.url, this.headers}) : super();
}

class MediaMemoryContents extends MediaContents {
  final Uint8List binary;

  const MediaMemoryContents({this.binary}) : super();
}
