import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/photo.dart';

class PhotoWidget extends StatelessWidget {
  final Photo photo;

  const PhotoWidget({Key key, @required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${photo.id}',
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text(photo.checksum),
      isThreeLine: true,
      subtitle: Text(photo.mimeType),
      dense: true,
    );
  }
}
