import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final AnimationController animationController;
  final double percent;
  final String progressText;

  const LoadingWidget(
      {this.animationController, this.percent, this.progressText});

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
        ],
      ),
    );
  }
}
