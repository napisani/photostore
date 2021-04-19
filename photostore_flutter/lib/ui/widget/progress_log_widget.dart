import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/progress_log.dart';

class ProgressLogWidget extends StatefulWidget {
  final ProgressLog progressLog;

  const ProgressLogWidget({Key key, this.progressLog}) : super(key: key);

  @override
  _ProgressLogWidgetState createState() => _ProgressLogWidgetState();
}

class _ProgressLogWidgetState extends State<ProgressLogWidget> {
  Stream<List<ProgressStats>> _stats;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _stats = this.widget.progressLog?.getStatsAsStream();
    _stats?.listen((event) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _stats != null
        ? StreamBuilder(
            stream: _stats,
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data.length > 0
                  ? SingleChildScrollView(
                      controller: _scrollController,
                      // reverse: true,
                      child: DataTable(columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'ID',
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                          ),
                        ),
                      ], rows: [
                        ...snapshot.data
                            .map((e) => DataRow(cells: [
                                  DataCell(Container(
                                    child: Text(e.id),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  )),
                                  DataCell(Container(
                                    child: Text(e.status),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  )),
                                ]))
                            .toList()
                      ]),
                    )
                  : Container();
            })
        : Container();
  }
}
