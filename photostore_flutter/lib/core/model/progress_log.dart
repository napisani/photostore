import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ProgressLog {
  Subject<List<ProgressStats>> _sub =
      new ReplaySubject<List<ProgressStats>>(maxSize: 1);
  List<ProgressStats> progressStats = [];
  final int maxSize;
  bool _hasTrimmed = false;

  ProgressLog({this.maxSize = 10});

  void clear() {
    progressStats = [];
    notifyUpdate();
  }

  void add(ProgressStats stat) {
    progressStats.add(stat);
    if (progressStats.length > maxSize) {
      progressStats.removeAt(0);
      _hasTrimmed = true;
    }
    this.notifyUpdate();
  }

  void addAll(Iterable<ProgressStats> stats) {
    stats.forEach((element) {
      this.add(element);
    });
  }

  void notifyUpdate() {
    print('ProgressLog - notifyUpdate ${this.progressStats}');
    this._sub.sink.add([...progressStats]);
  }

  bool hasBeenTrimmed() => _hasTrimmed;

  Stream<List<ProgressStats>> getStatsAsStream() => _sub.stream;

  void dispose() {
    _sub.close();
  }
}

class ProgressStats {
  final String id;
  String status = "";
  String details = "";
  ProgressLog log;
  Color color = Colors.black;

  ProgressStats({this.id, this.status, this.log, this.details}) {
    this._updateColor();
    this?.log?.notifyUpdate();
  }

  void _updateColor() {
    if (status?.toUpperCase() == "DONE") {
      color = Colors.green;
    }
    if (status != null && status.toUpperCase().startsWith("ERROR")) {
      color = Colors.red;
    }
  }

  void updateStatus(String status, {String details}) {
    this.status = status;
    this.details = details;
    this._updateColor();
    this?.log?.notifyUpdate();
  }

  void setLog(ProgressLog log) {
    this.log = log;
  }
}
