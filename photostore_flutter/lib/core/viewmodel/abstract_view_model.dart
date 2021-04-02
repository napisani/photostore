import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/viewmodel_ticker_provider.dart';

abstract class AbstractViewModel
    with ChangeNotifier, ViewModelTickerProviderMixin {
  @protected
  ScreenStatus screenStatus = ScreenStatus.uninitialized();

  ScreenStatus get status => screenStatus;

  List<StreamSubscription> _subs = [];

  set status(ScreenStatus s) => this.screenStatus = s;

  AbstractViewModel() {
    createDefaultTicker(this, this.notifyListeners);
  }

  List<StreamSubscription> addSubscription(StreamSubscription sub) =>
      _subs..add(sub);

  bool isAnimating() => this.status is LoadingScreenStatus;

  dispose() {
    super.dispose();
    killTicker();
    _subs.forEach((sub) {
      try {
        sub.cancel();
      } catch (e, s) {
        print('failed to cancel subscription $e stack: $s');
      }
    });
  }
}
