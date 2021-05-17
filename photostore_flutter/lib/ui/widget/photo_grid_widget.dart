import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/ui/widget/thumbnail_widget.dart';

class PhotoGridWidget extends StatelessWidget {
  final Pagination<AgnosticMedia> photos;
  final Iterable<int> selectedPhotos;
  final ScrollController _scrollController;
  final ValueChanged<int> _onPress;
  final ValueChanged<int> _onLongPress;
  final Function _onRefresh;

  final double currentScrollPosition;

  const PhotoGridWidget(
      {Key key,
      @required this.photos,
      scrollController,
      onPress,
      onRefresh,
      this.currentScrollPosition,
      onLongPress,
      @required this.selectedPhotos})
      : this._scrollController = scrollController,
        this._onPress = onPress,
        this._onRefresh = onRefresh,
        this._onLongPress = onLongPress,
        super(key: key);

  int _getImageCount(BuildContext context) {
    int count = (MediaQuery.of(context).size.width / 125).floor();
    if (count == 0) {
      count = 1;
    }
    if (count >= 6) {
      count = 6;
    }
    return count;
  }


  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) => {_scrollController.jumpTo(this.currentScrollPosition)});

    return RefreshIndicator(
        child: GridView.builder(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: this.photos.items.length,
          // reverse: true,
          // shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getImageCount(context)),
          itemBuilder: (context, index) => new Card(
            child: new GridTile(
              // footer: new Text(this.photos.items[index].id.toString()),
              child: GestureDetector(
                  onTap: () => _onPress(index),
                  onLongPress: () => _onLongPress(index),
                  child: ThumbnailWidget(
                    photo: photos.items[index],
                    selected: selectedPhotos.contains(index),
                  )),
            ),
          ),
          controller: _scrollController,
        ),
        onRefresh: _doRefresh);
  }

  Future<void> _doRefresh() async {
    print('inside _doRefresh');
    if (_onRefresh != null) {
      _onRefresh();
    }
  }
}
