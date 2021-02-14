import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

mixin BehaviorSubjectBlocMixin<TState> on Cubit<TState> {
  StreamSubscription<TState> listenWithCurrent(void Function(TState state) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    onData(this.state);
    return super.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }


}
//
//
// extension ListenWithCurrent<State, Event> on Bloc<State, Event> {
//
// }