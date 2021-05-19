import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/server_refinement_model.dart';
import 'package:photostore_flutter/ui/widget/common_status_widget.dart';
import 'package:provider/provider.dart';

class ServerRefinementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ServerRefinementModel(),
        child: _ServerRefinementScreen());
  }
}

class _ServerRefinementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServerRefinementModel>(builder: (context, state, child) {
      Widget inner;
      if (state?.status != null && state?.status is SuccessScreenStatus) {
        inner = _buildPanel(context, state);
      } else {
        inner = CommonStatusWidget(
          status: state.status,
          onInit: () => state.reinit(),
          onErrorDismiss: () => state.reinit(),
        );
      }
      return Scaffold(
          appBar: AppBar(title: const Text('Filters')),
          body: ListView(children: [
            Center(
                child: Wrap(children: [
              if (state.isDeviceSelected())
                ActionChip(
                  onPressed: () => state.clearDevice(),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: const Icon(Icons.clear),
                  ),
                  label: Text("Device: ${state.selectedDevice.deviceId}"),
                ),
              if (state.isAlbumSelected())
                ActionChip(
                  onPressed: () => state.clearAlbum(),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: Icon(Icons.clear),
                  ),
                  label: Text("Album: ${state.selectedAlbum.name}"),
                ),
              if (state.isDateSelected())
                ActionChip(
                  onPressed: () => state.clearDate(),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: const Icon(Icons.clear),
                  ),
                  label: Text(
                      "Date: ${DateFormat.yMMMM('en_US').format(state.selectedDate)}"),
                )
            ])),
            inner
          ]));
    });
  }

  Widget _buildPanel(BuildContext context, ServerRefinementModel state) {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          switch (index) {
            case 0:
              state.toggleExpandDevice();
              break;
            case 1:
              state.toggleExpandAlbum();
              break;
            case 2:
              state.toggleExpandDate();
              break;
          }
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text('Device'),
              );
            },
            body: ListTile(
                subtitle: Container(
              width: MediaQuery.of(context).size.width,
              child: ToggleButtons(
                direction: Axis.vertical,
                children: <Widget>[
                  ...state.deviceOptions
                      .map((device) => Text(device.deviceId))
                      .toList()
                ],
                onPressed: (int index) {
                  state.selectDevice(state.deviceOptions[index]);
                },
                isSelected: state.deviceOptions
                    .map((e) => e == state.selectedDevice)
                    .toList(),
              ),
            )),
            isExpanded: state.deviceExpanded,
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text('Album'),
              );
            },
            body: ListTile(
                subtitle: Container(
              width: MediaQuery.of(context).size.width,
              child: ToggleButtons(
                direction: Axis.vertical,
                children: <Widget>[
                  ...state.albumOptions
                      .map((album) => Text(album.name))
                      .toList()
                ],
                onPressed: (int index) {
                  state.selectAlbum(state.albumOptions[index]);
                },
                isSelected: state.albumOptions
                    .map((e) => e == state.selectedAlbum)
                    .toList(),
              ),
            )),
            isExpanded: state.albumExpanded,
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text('Date'),
              );
            },
            body: ListTile(
                subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.dateRanges.modifiedDateStart != null &&
                    state.dateRanges.modifiedDateEnd != null &&
                    state.selectedDate == null)
                  ElevatedButton(
                      onPressed: () {
                        showMonthPicker(
                          context: context,
                          firstDate: state.dateRanges.modifiedDateStart,
                          lastDate: state.dateRanges.modifiedDateEnd,
                          initialDate: state.selectedDate ?? DateTime.now(),
                          locale: Locale("en"),
                        ).then((date) {
                          if (date != null) {
                            state.selectDate(date);
                          }
                        });
                      },
                      child: Text("Select Date"))
                else if (state.selectedDate != null) ...[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Older than: ${DateFormat.yMMMM('en_US').format(state.selectedDate)}')),
                  ElevatedButton(
                      child: Text("Clear"),
                      onPressed: () {
                        state.selectDate(null);
                      })
                ]
              ],
            )),
            isExpanded: state.dateExpanded,
          ),
        ]);
  }
}
