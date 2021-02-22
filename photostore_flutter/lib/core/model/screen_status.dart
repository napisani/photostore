import 'package:flutter/material.dart';

enum ScreenStatusType { UNINITIALIZED, LOADING, SUCCESS, ERROR }

class ScreenStatus {
  final ScreenStatusType type;
  final String error;

  ScreenStatus({@required this.type, this.error});

  factory ScreenStatus.uninitialized() {
    return ScreenStatus(type: ScreenStatusType.UNINITIALIZED);
  }

  factory ScreenStatus.loading() {
    return ScreenStatus(type: ScreenStatusType.LOADING);
  }

  factory ScreenStatus.success() {
    return ScreenStatus(type: ScreenStatusType.SUCCESS);
  }

  factory ScreenStatus.error(String error) {
    return ScreenStatus(type: ScreenStatusType.ERROR, error: error);
  }
}
