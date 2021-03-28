import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/media_contents.dart';
import 'package:photostore_flutter/core/model/pagination.dart';

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
                child: FutureBuilder<MediaContents>(
                  future: photos.items[index].getThumbnail(),
                  builder: (context, AsyncSnapshot<MediaContents> snapshot) {
                    if (snapshot.hasData) {
                      // print('grid tile build - hasData');
                      if (snapshot.data is MediaURLContents) {
                        // print('grid tile build - returning image.network');

                        return Image.network(
                          (snapshot.data as MediaURLContents).url,
                          loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null ?
                                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        );
                      } else {
                        // print('grid tile build - returning image.memory');

                        return Image.memory(
                            (snapshot.data as MediaMemoryContents).binary);
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
          controller: _scrollController,
        ),
        onRefresh: _doRefresh);
  }

  Future<void> _doRefresh() async {
    print('inside _doRefresh');
    if(_onRefresh != null){
      _onRefresh();
    }
  }
}
