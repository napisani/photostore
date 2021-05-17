import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/media_contents.dart';

class ThumbnailWidget extends StatefulWidget {
  final AgnosticMedia photo;
  final bool selected;

  const ThumbnailWidget({Key key, @required this.photo, this.selected = false})
      : super(key: key);

  @override
  _ThumbnailWidgetState createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {
  Future<MediaContents> thumbFuture;

  @override
  void initState() {
    thumbFuture = widget.photo.getThumbnail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('build again');
    return FutureBuilder<MediaContents>(
      future: thumbFuture,
      builder: (context, AsyncSnapshot<MediaContents> snapshot) {
        if (snapshot.hasData) {
          // print('grid tile build - hasData');
          Widget img;
          if (snapshot.data is MediaURLContents) {
            // print('grid tile build - returning image.network');
            img = Image.network(
              (snapshot.data as MediaURLContents).url,
              headers: (snapshot.data as MediaURLContents).headers,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null &&
                            loadingProgress.expectedTotalBytes != 0
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            );
          } else {
            // print('grid tile build - returning image.memory');
            img = Image.memory((snapshot.data as MediaMemoryContents).binary);
          }
          return Stack(
            children: <Widget>[
              Center(child: img),
              if (widget.selected)
                Positioned(
                  bottom: 5,
                  right: 5,
                  //give the values according to your requirement
                  child: Icon(Icons.check_circle, color: Colors.green),
                ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
