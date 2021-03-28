import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenErrorWidget extends StatelessWidget {
  final String err;
  final Function onDismiss;

  ScreenErrorWidget({@required this.err, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final black = Color(0xFF000000);
    final red = Color(0xFFFF0000);
    return Container(
        child: Column(
            children: [
      Text(
        err,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: red,
          fontFamily: 'Courier',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          inherit: false,
        ),
      ),
      onDismiss == null
          ? null
          : ElevatedButton(onPressed: onDismiss, child: Text("Dismiss"))
    ].where((widget) => widget != null).toList()));
  }
}
