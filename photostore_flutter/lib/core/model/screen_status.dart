import 'package:flutter/cupertino.dart';

enum ScreenStatusType { UNINITIALIZED, LOADING, SUCCESS, ERROR }

abstract class ScreenStatus {
  // final ScreenStatusType type;
  // controller = AnimationController(
  // vsync: this,
  // duration: const Duration(seconds: 5),
  // )

  @protected
  const ScreenStatus();

  factory ScreenStatus.uninitialized() {
    return UninitializedScreenStatus();
  }

  factory ScreenStatus.loading(TickerProvider vsync,
      {percent = -1.0, progressText = ''}) {
    return LoadingScreenStatus(vsync,
        percent: percent, progressText: progressText);
  }

  factory ScreenStatus.success() {
    return SuccessScreenStatus();
  }

  factory ScreenStatus.error(String error) {
    return ErrorScreenStatus(error: error);
  }

  ScreenStatusType get type;
}

class UninitializedScreenStatus extends ScreenStatus {
  @override
  ScreenStatusType get type => ScreenStatusType.UNINITIALIZED;
}

class LoadingScreenStatus extends ScreenStatus {
  AnimationController loadingAnimationController;
  final double percent;
  final String progressText;

  LoadingScreenStatus(TickerProvider vsync,
      {this.percent = -1.0, this.progressText = ''})
      : super() {
    loadingAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 5),
    );
    loadingAnimationController.repeat(reverse: false);
  }

  @override
  ScreenStatusType get type => ScreenStatusType.LOADING;
}

class SuccessScreenStatus extends ScreenStatus {
  @override
  ScreenStatusType get type => ScreenStatusType.SUCCESS;
}

class ErrorScreenStatus extends ScreenStatus {
  final String error;

  ErrorScreenStatus({this.error});

  @override
  ScreenStatusType get type => ScreenStatusType.ERROR;
}
