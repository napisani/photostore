import 'package:flutter/material.dart';
import 'package:photostore_flutter/core/model/screen_status.dart';
import 'package:photostore_flutter/core/viewmodel/viewmodel_ticker_provider.dart';

abstract class AbstractViewModel
    with ChangeNotifier, ViewModelTickerProviderMixin {
  @protected
  ScreenStatus screenStatus = ScreenStatus.uninitialized();

  ScreenStatus get status => screenStatus;

  set status(ScreenStatus s) => this.screenStatus = s;

  AbstractViewModel() {
    createDefaultTicker(this, this.notifyListeners);
  }

  bool isAnimating() => this.status is LoadingScreenStatus;

  dispose(){
    super.dispose();
    killTicker();
  }
}
