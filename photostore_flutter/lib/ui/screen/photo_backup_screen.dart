import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/backup_model.dart';
import 'package:provider/provider.dart';

class PhotoBackupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BackupModel(), child: _PhotoBackupScreen());
  }
}

class _PhotoBackupScreen extends StatefulWidget {
  _PhotoBackupScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoBackupScreenState();
}

class _PhotoBackupScreenState extends State<_PhotoBackupScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text("Backup to Server"),
    //     ),
    //     // add this body tag with container and photoview widget
    //     body: Text('test'));

    return Consumer<BackupModel>(builder: (context, state, child) {
      // final model = Provider.of<BackupModel>(context);
      final bool preparingPhotoBackupQueue = false;
      if (state == null ||
          state.screenStatus.type == ScreenStatusType.UNINITIALIZED) {
        return Center(
          child: RaisedButton(
            child: Text(
              "Load",
            ),
            onPressed: () {
              state.load();
            },
          ),
        );
      } else if (state.screenStatus.type == ScreenStatusType.ERROR) {
        return Center(
          child: Text("Error occurred: ${state.screenStatus.error}"),
        );
      } else if (state.screenStatus.type == ScreenStatusType.SUCCESS) {
        if (state.queuedPhotos == null || state.queuedPhotos.length == 0) {
          return Center(
            child: RaisedButton(
                child: Text(preparingPhotoBackupQueue
                    ? 'Preparing Backup'
                    : 'Prepare Backup'),
                onPressed: () =>
                    preparingPhotoBackupQueue ? null : _prepareBackup()),
          );
        } else {
          return Center(
            child: Text('loaded'),
          );
        }
      } else {
        return Center(
          child: Text('state type: ${state.screenStatus.type}'),
        );
      }
    });
  }

  void _prepareBackup() {}
}
