import 'package:equatable/equatable.dart';
import 'package:photostore_flutter/models/media_contents.dart';

abstract class AgnosticMedia extends Equatable {
  final String id;
  final creationDate;
  final Future<MediaContents> thumbnail;

  const AgnosticMedia({this.id, this.creationDate, this.thumbnail}) : super();

  @override
  List<Object> get props => [id, creationDate];
}
