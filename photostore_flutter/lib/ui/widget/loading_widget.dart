import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final AnimationController animationController;
  final double percent;
  final String progressText;
  final Function onCancel;
  final Function onPause;
  final Function onResume;
  final bool isPaused;

  const LoadingWidget(
      {this.animationController,
      this.percent = -1,
      this.progressText,
      this.onCancel,
      this.onPause,
      this.onResume,
      this.isPaused});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            progressText == null || progressText == ''
                ? 'Loading...'
                : progressText,
            style: Theme.of(context).textTheme.headline6,
          ),
          CircularProgressIndicator(
            value: percent < 0 ? animationController.value : percent,
            semanticsLabel: 'Loading',
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                this.onCancel == null
                    ? null
                    : ElevatedButton(
                        child: Text("Cancel"),
                        onPressed: onCancel,
                      ),
                this.onPause == null || this.isPaused
                    ? null
                    : ElevatedButton(
                        child: Text("Pause"),
                        onPressed: onPause,
                      ),
                this.onResume == null || !this.isPaused
                    ? null
                    : ElevatedButton(
                        child: Text("Resume"),
                        onPressed: onResume,
                      )
              ].where((element) => element != null).toList()),
        ].where((element) => element != null).toList(),
      ),
    );
  }
}
