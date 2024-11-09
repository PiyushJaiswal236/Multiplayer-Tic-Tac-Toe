
import "package:flutter/material.dart";
import "package:socket_io_client/socket_io_client.dart";

class SocketClient {
  Socket? socket;
  static SocketClient? _instance;
  //internal constructor
  SocketClient.internal(BuildContext context) {
    socket = io(
        'http://multiplayer-tic-tac-toe-78eh.onrender.com',
        OptionBuilder()
            .disableAutoConnect()
            .setTransports(['websocket']).build());

    socket?.connect();
  }
  //function to return Singleton instance of _instance variable
   static SocketClient instance(BuildContext context) {
    _instance ??= SocketClient.internal(context);   //initializes _instance if not initalized
    return _instance!;
  }
}
