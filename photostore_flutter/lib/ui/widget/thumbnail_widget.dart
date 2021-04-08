import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/agnostic_media.dart';
import 'package:photostore_flutter/core/model/media_contents.dart';

class ThumbnailWidget extends StatelessWidget {
  final AgnosticMedia photo;

  const ThumbnailWidget({Key key, @required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MediaContents>(
      future: photo.getThumbnail(),
      builder: (context, AsyncSnapshot<MediaContents> snapshot) {
        if (snapshot.hasData) {
          // print('grid tile build - hasData');
          if (snapshot.data is MediaURLContents) {
            // print('grid tile build - returning image.network');

            return Image.network(
              (snapshot.data as MediaURLContents).url,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            );
          } else {
            // print('grid tile build - returning image.memory');

            return Image.memory((snapshot.data as MediaMemoryContents).binary);
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
