import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef FutureBytesGetter = Future<Uint8List> Function();

class FutureMemoryImage extends ImageProvider<FutureMemoryImage> {
  /// The bytes to decode into an image.
  final FutureBytesGetter getBytesFuture;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// Creates an object that decodes a [Uint8List] buffer as an image.
  ///
  /// The arguments must not be null.
  const FutureMemoryImage(this.getBytesFuture, {this.scale = 1.0})
      : assert(getBytesFuture != null),
        assert(scale != null);

  @override
  Future<FutureMemoryImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<FutureMemoryImage>(this);
  }

  @override
  ImageStreamCompleter load(FutureMemoryImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: 'MemoryImage(${describeIdentity(key.getBytesFuture)})',
    );
  }

  Future<Codec> _loadAsync(
      FutureMemoryImage key, DecoderCallback decode) async {
    assert(key == this);

    final Uint8List bin = await getBytesFuture();
    return decode(bin);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is FutureMemoryImage &&
        other.getBytesFuture == getBytesFuture &&
        other.scale == scale;
  }

  @override
  int get hashCode => hashValues(getBytesFuture.hashCode, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'FutureMemoryImage')}(${describeIdentity(getBytesFuture)}, scale: $scale)';
}
