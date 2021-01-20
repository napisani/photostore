import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String serverIP;
  final int serverPort;
  final bool https;

  const AppSettings(this.serverIP, this.serverPort, this.https);

  @override
  List<Object> get props => [serverIP, serverPort, https];
}
