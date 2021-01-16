abstract class AgnosticPhoto extends Equatable {
  final String id;
  final creationDate;

  const AgnosticPhoto({this.id, this.creationDate});

  @override
  List<Object> get props => [id, creationDate];
}
