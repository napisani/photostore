import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertMessage extends StatelessWidget {
  final String header;
  final String message;
  final LinkedHashMap<String, Function> actions;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    actions.forEach((key, value) {
      children.add(ElevatedButton(
        child: Text(key),
        onPressed: () {
          if (value != null) {
            value();
          }
          Navigator.of(context).pop(); // dismiss dialog
        },
      ));
    });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(header),
      content: Text(message),
      actions: children,
    );
    return alert;
  }

  AlertMessage({this.header, this.message, this.actions});
}
