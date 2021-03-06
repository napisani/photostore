import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String serverIP;
  final int serverPort;
  final bool https;
  final String deviceID;
  final String apiKey;

  /* advanced */
  final int batchSize;
  final int itemsPerPage;
  final int uploadRetryAttempts;
  final int connectTimeout; // in seconds
  final int receiveTimeout; // in seconds

  final double deviceWidth;
  final double deviceHeight;

  const AppSettings({
    this.serverIP,
    this.serverPort,
    this.https,
    this.deviceID,
    this.apiKey,
    this.batchSize,
    this.itemsPerPage,
    this.uploadRetryAttempts,
    this.connectTimeout,
    this.receiveTimeout,
    this.deviceWidth,
    this.deviceHeight,
  });

  AppSettings cloneWith(
      {String serverIP,
      int serverPort,
      bool https,
      String deviceID,
      String apiKey,
      int batchSize,
      int itemsPerPage,
      int uploadRetryAttempts,
      int connectTimeout,
      int receiveTimeout,
      double deviceWidth,
      double deviceHeight}) {
    bool newHttpsVal = this.https;
    if (https != null) {
      newHttpsVal = https;
    }
    return AppSettings(
        serverIP: serverIP ?? this.serverIP,
        serverPort: serverPort ?? this.serverPort,
        https: newHttpsVal,
        deviceID: deviceID ?? this.deviceID,
        apiKey: apiKey ?? this.apiKey,
        batchSize: batchSize ?? this.batchSize,
        itemsPerPage: itemsPerPage ?? this.itemsPerPage,
        uploadRetryAttempts: uploadRetryAttempts ?? this.uploadRetryAttempts,
        connectTimeout: connectTimeout ?? this.connectTimeout,
        receiveTimeout: receiveTimeout ?? this.receiveTimeout,
        deviceWidth: deviceWidth ?? this.deviceWidth,
        deviceHeight: deviceHeight ?? this.deviceHeight);
  }

  @override
  List<Object> get props => [
        serverIP,
        serverPort,
        https,
        deviceID,
        apiKey,
        batchSize,
        itemsPerPage,
        uploadRetryAttempts,
        connectTimeout,
        receiveTimeout,
        deviceWidth,
        deviceHeight
      ];
}
