import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/abstract_photo_page_model.dart';
import 'package:photostore_flutter/core/viewmodel/mobile_media_page_model.dart';
import 'package:photostore_flutter/core/viewmodel/server_media_page_model.dart';
import 'package:photostore_flutter/ui/screen/photo_gallery_screen.dart';
import 'package:photostore_flutter/ui/screen/photo_page_notifier_mixin.dart';
import 'package:photostore_flutter/ui/widget/loading_widget.dart';
import 'package:photostore_flutter/ui/widget/photo_grid_widget.dart';
import 'package:photostore_flutter/ui/widget/screen_error_widget.dart';
import 'package:provider/provider.dart';

class PhotoListTabWidget extends StatelessWidget {
  final String mediaSource;
  final ValueChanged<int> onPush;

  const PhotoListTabWidget({Key key, this.mediaSource, this.onPush})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return mediaSource == 'MOBILE'
        ? ChangeNotifierProvider<MobileMediaPageModel>(
            create: (context) => MobileMediaPageModel(),
            child: PhotoListWidget(mediaSource: mediaSource))
        : ChangeNotifierProvider<ServerMediaPageModel>(
            create: (context) => ServerMediaPageModel(),
            child: PhotoListWidget(mediaSource: mediaSource),
          );

    print('working on mediaSource: $mediaSource');
    return PhotoListWidget(mediaSource: mediaSource);
  }
}

class PhotoListWidget extends StatefulWidget {
  final String mediaSource;

  const PhotoListWidget({Key key, @required this.mediaSource})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoListWidgetState();
}

class _PhotoListWidgetState extends State<PhotoListWidget>
    with PhotoPageNotifierMixin {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  AbstractPhotoPageModel _photoPageModel;
  double _curOffset = 0;

  @override
  void initState() {
    super.initState();
    print('init state mediaSource: ${widget.mediaSource}');
    // _scrollController.addListener(_onScroll);
    // _photoPageModel = getPhotoPageViewModel(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) => _loadedEnoughYet());
  }

  @override
  void didChangeDependencies() {
    print('inside didChangeDependencies');
    super.didChangeDependencies();
    _scrollController.addListener(_onScroll);
    _photoPageModel = getPhotoPageViewModel(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadedEnoughYet());
  }

  bool _hasPhotosLoaded() =>
      _photoPageModel.photoPage != null &&
      _photoPageModel.photoPage.items.isNotEmpty;

  void _loadedEnoughYet() {
    if (_hasPhotosLoaded() ||
        _photoPageModel.status.type != ScreenStatusType.UNINITIALIZED) {
      print('after first paint');
      try {
        _scrollController.position;
        print('we are already attached to a scroll view');
        _onScroll();
      } catch (_) {
        _photoPageModel.loadPage(_nextPageNumber());
        print('adding fetch!');
      }
    }
  }

  void _adjustScrollOffset() {
    _scrollController.jumpTo(_curOffset);
  }

  @override
  Widget build(BuildContext context) {
    return getBlockBuilder(
      builder: (context, s, child) {
        final AbstractPhotoPageModel state = s;
        if (state == null ||
            state.status.type == ScreenStatusType.UNINITIALIZED) {
          // _photoPageModel.loadPage(_nextPageNumber());
          return Center(
            child: ElevatedButton(
              child: Text(
                "Load",
              ),
              onPressed: () {
                _photoPageModel.loadPage(_nextPageNumber());
              },
            ),
          );
        } else if (state.status is ErrorScreenStatus) {
          return Center(
              child: ScreenErrorWidget(
            err: (state.status as ErrorScreenStatus).error,
            onDismiss: () => state.reset(),
          ));
        }
        // else if (state.status.type == ScreenStatusType.LOADING) {
        //   return Center(
        //     child: Text("Loading..."),
        //   );
        // }
        else if (state.status.type == ScreenStatusType.SUCCESS ||
            state.status.type == ScreenStatusType.LOADING) {
          if ((state.photoPage?.items == null ||
              state.photoPage.items.isEmpty)) {
            print(
                'this: $this mediaSource: ${widget.mediaSource} building state type of: ${state.runtimeType}');
            print('scroll stats: $_scrollController');

            if (state.status is SuccessScreenStatus) {
              return Center(
                  child: Column(
                children: [
                  Text('no photos found'),
                  ElevatedButton(
                      child: Text('Reload'), onPressed: () => state.reset())
                ],
              ));
            } else if (state.status is LoadingScreenStatus) {
              return Center(
                child: LoadingWidget(
                  animationController: (state.status as LoadingScreenStatus)
                      .loadingAnimationController,
                ),
              );
            }
          }
          // Future.delayed(Duration.zero, () => _adjustScrollOffset());
          return PhotoGridWidget(
            photos: state.photoPage,
            scrollController: _scrollController,
            currentScrollPosition: _curOffset,
            onPress: (photo) => _handlePhotoSelected(photo),
            onRefresh: () {
              print('refresh called!');
              state.reset();
            },
          );
        } else {
          return Center(
            child: Text('invalid  state type: ${state.status.type}'),
          );
        }
      },
    );
  }

  void _handlePhotoSelected(int index) {
    print('loading index: $index');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoGalleryScreen(
            mediaSource: this.getMediaSource(), photoIndex: index),
      ),
    );

    // showDialog(context: context, builder: (_) => PhotoGalleryWidget());
  }

  @override
  void dispose() {
    print('in dispose');
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    print(
        "in _onScroll maxScroll: $maxScroll currentScroll: $currentScroll _scrollThreshold: $_scrollThreshold");
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _curOffset = currentScroll;
      _photoPageModel.loadPage(_nextPageNumber());
    }
  }

  int _nextPageNumber() {
    return (_photoPageModel?.photoPage?.page ?? 0) + 1;
  }

  @override
  String getMediaSource() {
    return widget.mediaSource;
  }
}
