import 'package:equatable/equatable.dart';

abstract class PhotoBackupEvent extends Equatable {
  final int timeEmitted;

  PhotoBackupEvent() : timeEmitted = DateTime
      .now()
      .millisecondsSinceEpoch;

  @override
  List<Object> get props => [];
}

class PhotoBackupResetEvent extends PhotoBackupEvent {
  PhotoBackupResetEvent() : super();
}
