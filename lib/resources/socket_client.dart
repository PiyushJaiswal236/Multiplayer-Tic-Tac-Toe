
import "package:flutter/material.dart";
import "package:socket_io_client/socket_io_client.dart";

class SocketClient {
  Socket? socket;
  static SocketClient? _instance;

  SocketClient.internal(BuildContext context) {
    socket = io(
        'http://192.168.14.209:3000',
        OptionBuilder()
            .disableAutoConnect()
            .setTransports(['websocket']).build());

    socket?.connect();
  }



   static SocketClient instance(BuildContext context) {
    _instance ??= SocketClient.internal(context);
    return _instance!;
  }
}
