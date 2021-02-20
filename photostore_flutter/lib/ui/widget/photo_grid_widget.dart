import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/media_contents.dart';
import 'package:photostore_flutter/core/model/pagination.dart';

class PhotoGridWidget extends StatelessWidget {
  final Pagination<AgnosticMedia> photos;
  final ScrollController _scrollController;
  final ValueChanged<int> _onPress;

  const PhotoGridWidget(
      {Key key, @required this.photos, scrollController, onPress})
      : this._scrollController = scrollController,
        this._onPress = onPress,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
            footer: new Text(this.photos.items[index].id.toString()),
            child: GestureDetector(
              onTap: () => _onPress(index),
              child: FutureBuilder<MediaContents>(
                future: photos.items[index].thumbnail,
                builder: (context, AsyncSnapshot<MediaContents> snapshot) {
                  if (snapshot.hasData) {
                    // print('grid tile build - hasData');
                    if (snapshot.data is MediaURLContents) {
                      // print('grid tile build - returning image.network');

                      return Image.network(
                          (snapshot.data as MediaURLContents).url,

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
    );
  }
}
