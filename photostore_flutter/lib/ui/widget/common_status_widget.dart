import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/ui/widget/loading_widget.dart';
import 'package:photostore_flutter/ui/widget/screen_error_widget.dart';

typedef CommonStatusWidgetBuilder = Widget Function(BuildContext context);


class CommonStatusWidget extends StatelessWidget {
  final ScreenStatus status;
  final Function onInit;
  final Function onErrorDismiss;
  final CommonStatusWidgetBuilder childUninit;
  final CommonStatusWidgetBuilder childError;
  final CommonStatusWidgetBuilder childLoading;
  final CommonStatusWidgetBuilder childDisabled;
  final CommonStatusWidgetBuilder childUnsupported;

  const CommonStatusWidget({
    Key key,
    @required this.status,
    @required this.onInit,
    @required this.onErrorDismiss,
    this.childUninit,
    this.childError,
    this.childLoading,
    this.childDisabled,
    this.childUnsupported,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == null || status.type == ScreenStatusType.UNINITIALIZED) {
      return this.childUninit == null
          ? Center(
              child: ElevatedButton(
              child: Text(
                "Load",
              ),
              onPressed: () {
                onInit();
              },
            ))
          : this.childUninit(context);
    } else if (status.type == ScreenStatusType.ERROR) {
      return childError == null
          ? Center(
              child: ScreenErrorWidget(
              err: (status as ErrorScreenStatus).error,
              onDismiss: () => onErrorDismiss(),
            ))
          : childError(context);
    } else if (status is LoadingScreenStatus) {
      return childLoading == null
          ? Center(
              child: LoadingWidget(
              animationController:
                  (status as LoadingScreenStatus).loadingAnimationController,
            ))
          : childLoading(context);
    } else if (status is DisabledScreenStatus) {
      return Center(
        child: childDisabled == null
            ? Text((status as DisabledScreenStatus).disabledText)
            : childDisabled(context),
      );
    } else {
      return childUnsupported == null
          ? Center(
              child: Text('invalid state type: ${status.type}'),
            )
          : childUnsupported(context);
    }
  }
}
