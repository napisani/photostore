import 'package:rxdart/rxdart.dart';

class RefinementButtonService {
  final BehaviorSubject<Function> _refinementOnPressed = BehaviorSubject<Function>();

  Stream<bool> shouldShowRefinementAsStream() =>
      _refinementOnPressed.stream.map((event) => event != null);

  void setRefinementOnPressedFunction(Function fnc) {
    this._refinementOnPressed.sink.add(fnc);
  }

  void disableRefinement() {
    this._refinementOnPressed.sink.add(null);
  }

  void dispose() {
    _refinementOnPressed.close();
  }
}
