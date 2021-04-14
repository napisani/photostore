import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/backup_stats.dart';

class BackupStatsWidget extends StatelessWidget {
  final BackupStats stats;

  const BackupStatsWidget({this.stats});

  @override
  Widget build(BuildContext context) {
    if (this.stats == null) {
      return null;
    }

    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Modified Date of last backed up photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'RobotoMono',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  stats.lastBackedUpPhotoModifyDate.isBefore(new DateTime(1200))
                      ? 'N/A'
                      : '${stats?.lastBackedUpPhotoModifyDate}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'RobotoMono',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "ID of last backed up photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${this.stats.lastBackedUpPhotoId == null ? 'N/A' : this.stats.lastBackedUpPhotoId}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Backed up Photo Count (for this device)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${this.stats.backedUpPhotoCount == null ? 'N/A' : this.stats.backedUpPhotoCount}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Mobile Device Photo Count)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${this.stats.mobilePhotoCount == null ? 'N/A' : this.stats.mobilePhotoCount}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

// @override
// Widget build(BuildContext context) {
//   if (this.stats == null) {
//     return null;
//   }
//   return Column(children: [
//     this.stats.lastBackedUpPhotoModifyDate.isBefore(new DateTime(1200))
//         ? Text("Last backed up Photo modified date: N/A")
//         : Text(
//             'Last backed up Photo modified date: ${this.stats?.lastBackedUpPhotoModifyDate}'),
//     Text(
//         'Last backed up Photo ID: ${this.stats.lastBackedUpPhotoId == null ? 'N/A' : this.stats.lastBackedUpPhotoId}'),
//     Text('Backed up Photo count: ${this.stats.backedUpPhotoCount}')
//   ]);
// }
}
