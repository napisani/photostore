import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/backup_model.dart';
import 'package:photostore_flutter/ui/widget/backup_stats_widget.dart';
import 'package:photostore_flutter/ui/widget/loading_widget.dart';
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

  showAlertDialog(
    BuildContext context,
    Function onContinue,
  ) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      onPressed: () {
        onContinue();
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Text(
          "Would you like to continue to delete all photos on the server associated with this device?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
          state.status.type == ScreenStatusType.UNINITIALIZED) {
        return Center(
            child: ElevatedButton(
          child: Text(
            "Load",
          ),
          onPressed: () {
            state.loadBackupStats();
          },
        ));
      } else if (state.status.type == ScreenStatusType.ERROR) {
        return Center(
            child: ScreenErrorWidget(
          err: (state.status as ErrorScreenStatus).error,
          onDismiss: () => state.reinit(),
        ));
      } else if (state.status.type == ScreenStatusType.LOADING) {
        return Center(
          child: LoadingWidget(
              animationController: (state.status as LoadingScreenStatus)
                  .loadingAnimationController,
              percent: (state.status as LoadingScreenStatus).percent,
              progressText: (state.status as LoadingScreenStatus).progressText,
              onCancel: state.cancelNotifier == null
                  ? null
                  : () => state.cancelNotifier?.cancel()),
        );
      } else if (state.status.type == ScreenStatusType.SUCCESS) {
        return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.backupFinished ? Text("Backup Complete!") : null,
                  Padding(
                      child: BackupStatsWidget(stats: state.stats),
                      padding: const EdgeInsets.all(15.0)),
                  state.queuedPhotos == null
                      ? Column(
                          children: [
                            ElevatedButton(
                                child: Text('Prepare Incremental Backup'),
                                onPressed: () =>
                                    state.loadIncrementalBackupQueue()),
                            ElevatedButton(
                                child: Text('Prepare Full Backup'),
                                onPressed: () => state.loadFullBackupQueue()),
                            ElevatedButton(
                                child: Text('Delete Photos on Server'),
                                onPressed: () => showAlertDialog(
                                    context, () => state.deletePhotos()))
                          ],
                        )
                      : Center(
                          child: Column(
                            children: [
                              ElevatedButton(
                                  child: Text(
                                      'Start backup of : ${state.queuedPhotos.length} Photos'),
                                  onPressed: () => state.doBackup()),
                              ElevatedButton(
                                  child: Text('Cancel'),
                                  onPressed: () => state.reinit())
                            ],
                          ),
                        ),
                ].where((child) => child != null).toList()));
      } else {
        return Center(
          child: Text('invalid state type: ${state.status.type}'),
        );
      }
    });
  }
}
