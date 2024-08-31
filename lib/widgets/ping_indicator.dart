
import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/providers/room_data_provider.dart';
import 'package:multiplayer_tick_tac_toe/resources/SocketService.dart';
import 'package:provider/provider.dart';


class PingIndicator extends StatefulWidget {
  const PingIndicator({super.key});

  @override
  State<StatefulWidget> createState() => _pingIndiacator();
}

class _pingIndiacator extends State<PingIndicator> {



  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();

    print("pring disposed");
  }


  @override
  Widget build(BuildContext context) {
    final RoomDataProvider roomDataProvider =
        Provider.of<RoomDataProvider>(context);
    return roomDataProvider.isConnected
        ? Text("Ping : ${roomDataProvider.latency}")
        : const Text("No Connection");
  }
}
