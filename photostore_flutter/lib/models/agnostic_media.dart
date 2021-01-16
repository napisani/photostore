import 'package:equatable/equatable.dart';

abstract class AgnosticMedia extends Equatable {
  final String id;
  final creationDate;

  const AgnosticMedia({this.id, this.creationDate}) : super();

  @override
  List<Object> get props => [id, creationDate];
}
