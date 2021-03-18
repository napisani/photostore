import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenErrorWidget extends StatelessWidget {
  final String err;
  final String buttonTitle;
  final VoidCallback onTap;

  const ScreenErrorWidget(
      {@required this.err, this.onTap, this.buttonTitle = "Dismiss"});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("An error occurred: ${err == null ? '' : err}"),
      RaisedButton(
        onPressed: this.onTap,
        child: Text(this.buttonTitle),
      )
    ]);
  }
}
