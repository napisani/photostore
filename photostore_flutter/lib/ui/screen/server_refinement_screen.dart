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
          Container(
              padding: EdgeInsets.all(10),
              child: Center(
                  child: Text(
                'Device Filter',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ))),
          ToggleButtons(
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
