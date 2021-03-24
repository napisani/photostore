import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/backup_model.dart';
import 'package:photostore_flutter/ui/widget/backup_stats_widget.dart';
import 'package:photostore_flutter/ui/widget/screen_error_widget.dart';
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
      if (state == null ||
          state.screenStatus.type == ScreenStatusType.UNINITIALIZED) {
        return Center(
            child: TextButton(
          child: Text(
            "Load",
          ),
          onPressed: () {
            state.loadBackupStats();
          },
        ));
      } else if (state.screenStatus.type == ScreenStatusType.ERROR) {
        return Center(
            child: ScreenErrorWidget(
          err: state.screenStatus.error,
          onDismiss: () => state.reinit(),
        ));
      } else if (state.screenStatus.type == ScreenStatusType.LOADING) {
        return Center(
          child: Text("Loading..."),
        );
      } else if (state.screenStatus.type == ScreenStatusType.SUCCESS) {
        return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.backupFinished ? Text("Backup Complete!") : null,
                  BackupStatsWidget(stats: state.stats),
                  state.queuedPhotos == null
                      ? Column(
                          children: [
                            TextButton(
                                child: Text('Prepare Incremental Backup'),
                                onPressed: () => state.loadIncrementalBackupQueue()),
                            TextButton(
                                child: Text('Prepare Full Backup'),
                                onPressed: () => state.loadFullBackupQueue())
                          ],
                        )
                      : Center(
                          child: TextButton(
                              child: Text(
                                  'photos to backup: ${state.queuedPhotos.length}'),
                              onPressed: () => state.doBackup()),
                        ),
                ].where((child) => child != null).toList()));
      } else {
        return Center(
          child: Text('invalid state type: ${state.screenStatus.type}'),
        );
      }
    });
  }
}
