import 'package:equatable/equatable.dart';

abstract class PhotoPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PhotoPageFetchEvent extends PhotoPageEvent {}
