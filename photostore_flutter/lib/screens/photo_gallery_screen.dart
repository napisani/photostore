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
    return _PhotoGalleryScreenWidget(
        mediaSource: mediaSource, photoIndex: photoIndex);
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
  int _idx;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _photoPageBloc = getPhotoPageBloc(context);
    _idx = widget.photoIndex;
    _pageController = PageController(initialPage: _idx);
  }

  @override
  Widget build(BuildContext context) {
    return getBlockBuilder(builder: (context, state) {
      print('this: $this mediaSource: ${widget.mediaSource}');
      if (state is PhotoPageStateInitial) {
        _photoPageBloc.add(PhotoPageFetchEvent(_nextPageNumber()));
        return Center(
          child: RaisedButton(
            child: Text(
              "Load",
            ),
            onPressed: () {
              _photoPageBloc.add(PhotoPageFetchEvent(_nextPageNumber()));
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
            title: Text("Photo View: $_idx of ${state.photos.total}"),
          ),
          // add this body tag with container and photoview widget
          body: PhotoViewGallery.builder(
            pageController: _pageController,
            onPageChanged: (newPage) {
              _idx = newPage;
              if (_idx >= state.photos.items.length - 1) {
                this._photoPageBloc.add(PhotoPageFetchEvent(_nextPageNumber()));
              }
            },
            itemCount: state.photos.total,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: state.photos.items[index]
                    .getThumbnailProviderOfSize(
                        (MediaQuery.of(context).size.width),
                        (MediaQuery.of(context).size.height)),
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

  int _nextPageNumber() {
    return (_photoPageBloc?.state?.photos?.page ?? 0) + 1;
  }

  @override
  String getMediaSource() => widget.mediaSource;
}
