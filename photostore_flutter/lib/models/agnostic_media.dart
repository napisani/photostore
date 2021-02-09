import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photostore_flutter/models/media_contents.dart';

abstract class AgnosticMedia extends Equatable {
  final String id;
  final creationDate;
  final Future<MediaContents> thumbnail;
  final ImageProvider thumbnailProvider;

  const AgnosticMedia({this.id, this.creationDate, this.thumbnail, this.thumbnailProvider}) : super();

  @override
  List<Object> get props => [id, creationDate];
}
