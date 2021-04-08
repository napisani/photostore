import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/pagination.dart';
import 'package:photostore_flutter/ui/widget/thumbnail_widget.dart';

class PhotoGridWidget extends StatelessWidget {
  final Pagination<AgnosticMedia> photos;
  final ScrollController _scrollController;
  final ValueChanged<int> _onPress;
  final Function _onRefresh;

  final double currentScrollPosition;

  const PhotoGridWidget(
      {Key key,
      @required this.photos,
      scrollController,
      onPress,
      onRefresh,
      this.currentScrollPosition})
      : this._scrollController = scrollController,
        this._onPress = onPress,
        this._onRefresh = onRefresh,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) => {_scrollController.jumpTo(this.currentScrollPosition)});

    return RefreshIndicator(
        child: GridView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: this.photos.items.length,
          // reverse: true,
          // shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 3
                      : 4),
          itemBuilder: (context, index) => new Card(
            child: new GridTile(
              // footer: new Text(this.photos.items[index].id.toString()),
              child: GestureDetector(
                  onTap: () => _onPress(index),
                  child: ThumbnailWidget(photo: photos.items[index])),
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
