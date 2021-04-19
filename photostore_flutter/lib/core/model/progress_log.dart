import 'package:rxdart/rxdart.dart';

class ProgressLog {
  Subject<List<ProgressStats>> _sub =
      new ReplaySubject<List<ProgressStats>>(maxSize: 1);
  List<ProgressStats> progressStats = [];
  final int maxSize;

  ProgressLog({this.maxSize = 10});

  void clear() {
    progressStats = [];
    notifyUpdate();
  }

  void add(ProgressStats stat) {
    progressStats.add(stat);
    if (progressStats.length > maxSize) {
      progressStats.removeAt(0);
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

  Stream<List<ProgressStats>> getStatsAsStream() => _sub.stream;

  void dispose() {
    _sub.close();
  }
}

class ProgressStats {
  final String id;
  String status = "";
  ProgressLog log;

  ProgressStats({this.id, this.status, this.log}) {
    this?.log?.notifyUpdate();
  }

  void updateStatus(String status) {
    this.status = status;
    this?.log?.notifyUpdate();
  }

  void setLog(ProgressLog log) {
    this.log = log;
  }
}
