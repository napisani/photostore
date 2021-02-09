import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photostore_flutter/blocs/abstract_photo_page_bloc.dart';
import 'package:photostore_flutter/models/event/photo_page_event.dart';
import 'package:photostore_flutter/models/state/photo_page_state.dart';
import 'package:photostore_flutter/screens/photo_bloc_mixins.dart';

class PhotoGalleryScreen extends StatelessWidget {
  final int photoIndex;
  final String mediaSource;

  const PhotoGalleryScreen(
      {@required this.photoIndex, @required this.mediaSource})
      : super();

  @override
  Widget build(BuildContext context) {
    return _PhotoGalleryScreenWidget(mediaSource: mediaSource, photoIndex: photoIndex);
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
  AbstractPhotoPageBloc _photoPageBloc;

  @override
  void initState() {
    super.initState();
    _photoPageBloc = getPhotoPageBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return getBlockBuilder(builder: (context, state) {
      print('this: $this mediaSource: ${widget.mediaSource}');
      if (state is PhotoPageStateInitial) {
        _photoPageBloc.add(PhotoPageFetchEvent());
        return Center(
          child: RaisedButton(
            child: Text(
              "Load",
            ),
            onPressed: () {
              _photoPageBloc.add(PhotoPageFetchEvent());
            },
          ),
        );
      } else if (state is PhotoPageStateFailure) {
        return Center(
          child: Text("Error occurred: ${state.errorMessage}"),
        );
      } else if (state is PhotoPageStateSuccess) {
        if (state.photos?.items == null || state.photos.items.isEmpty) {
          return Center(
            child: Text('no photos'),
          );
        }
        // Future.delayed(Duration.zero, () => _adjustScrollOffset());
        return Scaffold(
          appBar: AppBar(
            title: Text("Photo View + Zoomable widget"),
          ),
          // add this body tag with container and photoview widget
          body: PhotoViewGallery.builder(
            itemCount: state.photos.items.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: state.photos.items[index].thumbnailProvider,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
            // loadingChild: Center(
            //   child: CircularProgressIndicator(),
            // ),
          ),
        );
      } else {
        throw Exception("invalid PhotoPageState type");
      }
    });
  }

  @override
  String getMediaSource() => widget.mediaSource;
}
