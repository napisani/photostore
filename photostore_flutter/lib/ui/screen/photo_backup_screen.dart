import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/progress_log.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/backup_model.dart';
import 'package:photostore_flutter/ui/widget/backup_stats_widget.dart';
import 'package:photostore_flutter/ui/widget/common_status_widget.dart';
import 'package:photostore_flutter/ui/widget/loading_widget.dart';
import 'package:photostore_flutter/ui/widget/progress_log_widget.dart';
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

  String _horizontify(String str) => str.replaceAll(" ", "\n");

  Widget _buildBackupLog(BuildContext context, ProgressLog progressLog) {
    return Expanded(child: ProgressLogWidget(progressLog: progressLog));
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
      if (state?.status?.type == ScreenStatusType.SUCCESS) {
        return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.backupFinished
                      ? Text("Backup Complete!",
                          style: Theme.of(context).textTheme.headline6)
                      : null,
                  Padding(
                      child: BackupStatsWidget(stats: state.stats),
                      padding: const EdgeInsets.all(15.0)),
                  _buildBackupLog(context, state.progressLog),
                  state.queuedPhotos == null
                      ? ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                child: Text(
                                  _horizontify('Prepare Incremental Backup'),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () =>
                                    state.loadIncrementalBackupQueue()),
                            ElevatedButton(
                                child: Text(
                                  _horizontify('Prepare Full Backup'),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () => state.loadFullBackupQueue()),
                          ],
                        )
                      : Center(
                          child: ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  child: Text(
                                    'Start backup of:\n${state.queuedPhotos.length} Photos',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () => state.doBackup()),
                              ElevatedButton(
                                  child: Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () => state.reinit())
                            ],
                          ),
                        ),
                ].where((child) => child != null).toList()));
      }

      return CommonStatusWidget(
          status: state.status,
          onInit: () => state.loadBackupStats(),
          onErrorDismiss: () => state.reinit(),
          childLoading: (ctx) => Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    LoadingWidget(
                        animationController:
                            (state.status as LoadingScreenStatus)
                                .loadingAnimationController,
                        percent: (state.status as LoadingScreenStatus).percent,
                        progressText:
                            (state.status as LoadingScreenStatus).progressText,
                        onCancel: state.cancelNotifier == null
                            ? null
                            : () => state.cancelNotifier?.cancel(),
                        onPause: state.pauseNotifier == null
                            ? null
                            : () => state.pauseNotifier?.pause(),
                        onResume: state.pauseNotifier == null
                            ? null
                            : () => state.pauseNotifier?.resume(),
                        isPaused: state.pauseNotifier != null &&
                            state.pauseNotifier.hasBeenPaused),
                    _buildBackupLog(context, state.progressLog)
                  ])));
    });
  }
}
