import 'package:equatable/equatable.dart';

abstract class PhotoPageEvent extends Equatable {
  final int timeEmitted;

  PhotoPageEvent() : timeEmitted = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [];
}

class PhotoPageFetchEvent extends PhotoPageEvent {
  final int page;

  PhotoPageFetchEvent(this.page) : super();

  @override
  List<Object> get props => [];
}

class PhotoPageResetEvent extends PhotoPageEvent {
  PhotoPageResetEvent() : super();
}
