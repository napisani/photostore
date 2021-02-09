import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class FutureMemoryImage extends ImageProvider<FutureMemoryImage> {

  /// The bytes to decode into an image.
  final Future<Uint8List> bytesFuture;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;


  /// Creates an object that decodes a [Uint8List] buffer as an image.
  ///
  /// The arguments must not be null.
  const FutureMemoryImage(this.bytesFuture, { this.scale = 1.0 })
      : assert(bytesFuture != null),
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
      debugLabel: 'MemoryImage(${describeIdentity(key.bytesFuture)})',
    );
  }

  Future<Codec> _loadAsync(FutureMemoryImage key, DecoderCallback decode) async{
    assert(key == this);

    final Uint8List bin = await bytesFuture;
    return  decode(bin);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType)
      return false;
    return other is FutureMemoryImage
        && other.bytesFuture == bytesFuture
        && other.scale == scale;
  }

  @override
  int get hashCode => hashValues(bytesFuture.hashCode, scale);

  @override
  String toString() => '${objectRuntimeType(this, 'FutureMemoryImage')}(${describeIdentity(bytesFuture)}, scale: $scale)';
}