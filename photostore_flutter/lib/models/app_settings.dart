import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String serverIP;
  final int serverPort;
  final bool https;

  const AppSettings(this.serverIP, this.serverPort, this.https);

  AppSettings cloneWith({String serverIP, int serverPort, bool https}) {
    bool newHttpsVal = this.https;
    if (https != null) {
      newHttpsVal = https;
    }
    return AppSettings(
        serverIP ?? this.serverIP, serverPort ?? serverPort, newHttpsVal);
  }

  @override
  List<Object> get props => [serverIP, serverPort, https];
}
