import 'dart:collection';

import 'package:photostore_flutter/core/model/lockout_type.dart';

class LockoutService {
  Set<LockoutType> lockouts = HashSet<LockoutType>();

  void establishLockout(Iterable<LockoutType> types) {
    this.clearLockout();
    lockouts.addAll(types);
  }

  void establishAllLockout() {
    establishLockout([LockoutType.ALL]);
  }

  void clearLockout() {
    this.lockouts.clear();
  }

  bool isDisabled(LockoutType t) =>
      lockouts.contains(t) || lockouts.contains(LockoutType.ALL);

  void dispose() {}
}
