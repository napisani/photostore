import 'package:flutter/cupertino.dart';
import 'package:photostore_flutter/core/model/backup_stats.dart';

class BackupStatsWidget extends StatelessWidget {
  final BackupStats stats;

  const BackupStatsWidget({this.stats});

  @override
  Widget build(BuildContext context) {
    if (this.stats == null) {
      return null;
    }
    return Column(children: [
      this.stats.lastBackedUpPhotoModifyDate.isBefore(new DateTime(1200))
          ? Text("Last backed up Photo modified date: N/A")
          : Text(
              'Last backed up Photo modified date: ${this.stats?.lastBackedUpPhotoModifyDate}'),
      Text(
          'Last backed up Photo ID: ${this.stats.lastBackedUpPhotoId == null ? 'N/A' : this.stats.lastBackedUpPhotoId}'),
      Text('Backed up Photo count: ${this.stats.backedUpPhotoCount}')
    ]);
  }
}
