import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsHostnameInputWidget extends StatelessWidget {
  final String serverIP;
  final Function savePressed;

  SettingsHostnameInputWidget({ this.serverIP = "", this.savePressed}) {}

  @override
  Widget build(BuildContext context) {
    final TextEditingController txtController =
    TextEditingController();
    txtController.text = this.serverIP;
    return AlertDialog(
      title: Text("Enter Server Hostname/IP"),
      content: TextField(controller: txtController),
      actions: [
        FlatButton(
            onPressed: () {
              print('cancel pressed');
              Navigator.pop(context);
            },
            child: Text("Cancel")),
        FlatButton(
            onPressed: () {
              print(
                  'save pressed ${txtController.value.text}');
              Navigator.pop(context);
              if (savePressed != null) {
                savePressed.call(txtController.value.text);
              }
            },
            child: Text("Save"))
      ],
    );
  }

}
