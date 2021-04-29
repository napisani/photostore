import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/photo_gallery_view_model.dart';
import 'package:photostore_flutter/ui/widget/common_status_widget.dart';
import 'package:provider/provider.dart';

class PhotoGalleryScreen extends StatelessWidget {
  final int photoIndex;
  final String mediaSource;

  const PhotoGalleryScreen(
      {@required this.photoIndex, @required this.mediaSource})
      : super();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            PhotoGalleryViewModel(mediaSource, photoIndex: this.photoIndex),
        child: _PhotoGalleryScreen());
  }
}

class _PhotoGalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoGalleryViewModel>(builder: (context, state, child) {
      if (state.status is SuccessScreenStatus) {
        if (state.photoPage?.items == null || state.photoPage.items.isEmpty) {
          return Center(
              child: Column(
            children: [
              Text('no photos found'),
              ElevatedButton(
                  child: Text('Reload'), onPressed: () => state.reset())
            ],
          ));
        }
        // Future.delayed(Duration.zero, () => _adjustScrollOffset());
        return Scaffold(
          appBar: AppBar(
            title: Text("Photo View"),
          ),
          // add this body tag with container and photoview widget
          body: PhotoViewGallery.builder(
            pageController: state.pageController,
            onPageChanged: (newPage) {
              state.handlePhotoPageSwipe(newPage);
            },
            itemCount: state.photoPage.total,

            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: state.photoPage.items[index]
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
      }

      return CommonStatusWidget(
        status: state.status,
        onInit: () => state.loadNextPage(),
        onErrorDismiss: () => state.reset(),
      );
    });
  }
}
