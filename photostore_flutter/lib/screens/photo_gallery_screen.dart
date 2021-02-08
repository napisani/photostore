import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/screens/photo_bloc_mixins.dart';

class PhotoGalleryScreen extends StatelessWidget {
  final int photoIndex;
  final String mediaSource;

  const PhotoGalleryScreen(
      {@required this.photoIndex, @required this.mediaSource})
      : super();

  @override
  Widget build(BuildContext context) {
    return _PhotoGalleryScreenWidget();
  }
}

class _PhotoGalleryScreenWidget extends StatefulWidget {
  final String mediaSource;
  final int photoIndex;

  const _PhotoGalleryScreenWidget(
      {Key key, @required this.mediaSource, @required this.photoIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoGalleryScreenWidgetState();
}

class _PhotoGalleryScreenWidgetState extends State<_PhotoGalleryScreenWidget>
    with PhotoBlocMixins {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('works');
  }

  @override
  String getMediaSource() => widget.mediaSource;
}
