import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/photo_gallery_view_model.dart';
import 'package:photostore_flutter/ui/widget/alert_message.dart';
import 'package:photostore_flutter/ui/widget/common_status_widget.dart';
import 'package:photostore_flutter/ui/widget/download_dialog_widget.dart';
import 'package:provider/provider.dart';

class PhotoGalleryScreen extends StatelessWidget {
  final int photoIndex;
  final bool isAPIPhotos;

  final String mediaSource;

  const PhotoGalleryScreen(
      {@required this.photoIndex,
      @required this.isAPIPhotos,
      @required this.mediaSource})
      : super();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PhotoGalleryViewModel(mediaSource, isAPIPhotos,
            photoIndex: this.photoIndex),
        child: _PhotoGalleryScreen());
  }
}

class _PhotoGalleryScreen extends StatefulWidget {
  @override
  __PhotoGalleryScreenState createState() => __PhotoGalleryScreenState();
}

class __PhotoGalleryScreenState extends State<_PhotoGalleryScreen> {
  void _downloadPopup(context, PhotoGalleryViewModel state) {
    showDialog(
        context: context,
        builder: (context) => DownloadDialogWidget(
              onDownload: (type) => state.download(type),
            ));
  }

  void _showAlertDialog(BuildContext context, PhotoGalleryViewModel state) {
    // set up the buttons
    LinkedHashMap<String, Function> actions = LinkedHashMap();
    actions["NO"] = () => null;
    actions["YES"] = () async {
      await state.handleDeleteSinglePhoto();
      Navigator.of(context).pop();
    };
    AlertMessage alert = AlertMessage(
        actions: actions,
        header: "Delete Photo",
        message: "Are you sure you want to delete this photo?");
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _offsetPopup(context, PhotoGalleryViewModel state) =>
      PopupMenuButton<int>(
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text(
                    "Download",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
          onSelected: (value) {
            print('selected value: $value');
            if (value == 1) {
              _downloadPopup(context, state);
            } else if (value == 2) {
              _showAlertDialog(context, state);
            }
          },
          // icon: Icon(Icons.more_horiz),
          // backgroundColor: Colors.blue,
          icon: Container(
            child: Icon(Icons.more_horiz, color: Colors.white),
            height: double.infinity,
            width: double.infinity,
            decoration: ShapeDecoration(
                color: Colors.blue,
                shape: StadiumBorder(
                  side: BorderSide(color: Colors.white, width: 2),
                )),
            //child: Icon(Icons.menu, color: Colors.white), <-- You can give your icon here
          ));

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
              state.handlePhotoPageSwipe(newPage, context);
            },
            loadingBuilder: (ctx, _) => Center(child: CircularProgressIndicator()),
            itemCount: state.photoPage.total,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider:
                    state.getCurrentPhoto()?.thumbnailOfDeviceSizeProvider,
                // state.photoPage.items[index].getThumbnailProviderOfSize(
                //         (MediaQuery.of(context).size.width),
                //         (MediaQuery.of(context).size.height),
                //         context: context,
                //         precache: true)
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
          ),
          floatingActionButton:
              state.isAPIPhotos ? _offsetPopup(context, state) : null,
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
