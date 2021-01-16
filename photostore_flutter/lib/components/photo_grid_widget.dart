import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/models/agnostic_media.dart';
import 'package:photostore_flutter/models/pagination.dart';

class PhotoGridWidget extends StatelessWidget {
  final Pagination<dynamic> photos;
  final ScrollController _scrollController;

  const PhotoGridWidget({Key key, @required this.photos, scrollController})
      : this._scrollController = scrollController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: this.photos.items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              (MediaQuery.of(context).orientation == Orientation.portrait)
                  ? 3
                  : 4),
      itemBuilder: (context, index) => new Card(
        child: new GridTile(
            footer: new Text(this.photos.items[index].id.toString()),
            child: new Text(this
                .photos
                .items[index]
                .id
                .toString())), //just for testing, will fill with image later
      ),
      controller: _scrollController,
    );
  }
}
