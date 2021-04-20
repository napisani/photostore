import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/backup_stats.dart';

class BackupStatsWidget extends StatelessWidget {
  final BackupStats stats;

  const BackupStatsWidget({this.stats});

  Widget _buildCell(String data, {bool bold = false}) => TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            data,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'RobotoMono',
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );

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
            _buildCell("Modified Date of last backed up photo", bold: true),
            _buildCell(
                stats.lastBackedUpPhotoModifyDate.isBefore(new DateTime(1200))
                    ? 'N/A'
                    : '${stats?.lastBackedUpPhotoModifyDate}',
                bold: false)
          ],
        ),
        TableRow(
          children: <Widget>[
            _buildCell("ID of last backed up photo", bold: true),
            _buildCell(
                "${this.stats.lastBackedUpPhotoId == null ? 'N/A' : this.stats.lastBackedUpPhotoId}",
                bold: false)
          ],
        ),
        TableRow(
          children: <Widget>[
            _buildCell("Backed up Photo Count (for this device)", bold: true),
            _buildCell(
                "${this.stats.backedUpPhotoCount == null ? 'N/A' : this.stats.backedUpPhotoCount}",
                bold: false)
          ],
        ),
        TableRow(
          children: <Widget>[
            _buildCell("Mobile Device Photo Count", bold: true),
            _buildCell(
                "${this.stats.mobilePhotoCount == null ? 'N/A' : this.stats.mobilePhotoCount}",
                bold: false)
          ],
        )
      ],
    );
  }
}
