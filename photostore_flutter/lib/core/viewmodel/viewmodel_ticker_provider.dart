import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'abstract_view_model.dart';

mixin ViewModelTickerProviderMixin<T extends AbstractViewModel>
    implements TickerProvider {
  Ticker _ticker;

  Ticker createDefaultTicker(T viewModel, Function notifyListenersFunc) =>
      createTicker((elapsed) {
        if (_shouldTickNotifyChange(viewModel)) {
          // print('tick - elapsed: $elapsed');
          notifyListenersFunc();
        }
      });

  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker = Ticker(onTick);
    _ticker.start();
    return _ticker;
  }

  void killTicker() {
    if (_ticker != null) {
      try {
        _ticker.stop();
      } catch (_) {}
    }
  }

  bool _shouldTickNotifyChange(T viewModel) {
    return viewModel.isAnimating();
  }
}
