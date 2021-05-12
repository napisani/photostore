import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        inner = ListView(children: [
          ExpandablePanel(
            header: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Device Filter',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            collapsed: Text(
              'View device filters...',
            ),
            expanded: Container(
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
            ),
            // tapHeaderToExpand: true,
            // hasIcon: true,
          ),

          ExpandablePanel(
            header: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Albums',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            collapsed: Text(
              'View albums...',
            ),
            expanded: Container(
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
            ),
            // tapHeaderToExpand: true,
            // hasIcon: true,
          ),


        ]);
      } else {
        inner = CommonStatusWidget(
          status: state.status,
          onInit: () => state.reinit(),
          onErrorDismiss: () => state.reinit(),
        );
      }
      return Scaffold(
          appBar: AppBar(title: Text('Refinement Filters')), body: inner);
    });
  }
}
