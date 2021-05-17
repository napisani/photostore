import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/download_type.dart';


typedef DownloadCallback = Future<void> Function(DownloadType);

class DownloadDialogWidget extends StatelessWidget {
  final DownloadCallback onDownload;

  const DownloadDialogWidget({Key key, this.onDownload}) : super(key: key);


  @override
  Widget build(BuildContext context) =>
      AlertDialog(
        title: Text('Download'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              ElevatedButton(
                  child: Text('Thumbnail'),
                  onPressed: () async {
                    await onDownload(DownloadType.THUMB);
                    Navigator.of(context).pop();
                  }),
              ElevatedButton(
                  child: Text('Full size PNG'),
                  onPressed: () async {
                    await onDownload(DownloadType.FULL_PNG);

                    Navigator.of(context).pop();
                  }),
              ElevatedButton(
                  child: Text('Original File'),
                  onPressed: () async {
                    await onDownload(DownloadType.ORIG);
                    Navigator.of(context).pop();
                  })
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}
