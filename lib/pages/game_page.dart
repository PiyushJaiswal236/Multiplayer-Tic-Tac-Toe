import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/providers/room_data_provider.dart';
import 'package:multiplayer_tick_tac_toe/resources/SocketService.dart';
import 'package:multiplayer_tick_tac_toe/views/waiting_page.dart';
import 'package:multiplayer_tick_tac_toe/widgets/board.dart';
import 'package:multiplayer_tick_tac_toe/widgets/scoreboard.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  static String routeName = '/game-page';

  @override
  State<StatefulWidget> createState() => _gamePageState();
}

class _gamePageState extends State<GamePage> {
  final Socketservice _socketservice = Socketservice();

  @override
  void initState() {
    super.initState();
    _socketservice.roomUpdatedListener(context);
    _socketservice.updatePlayersListener(context);
  }

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);

    if (kDebugMode) {
      print("Player 1 : ${Provider.of<RoomDataProvider>(context).player1.nickname}");
      print("Player 2 : ${Provider.of<RoomDataProvider>(context).player2.nickname}");
    }

    return Scaffold(
        body: Provider.of<RoomDataProvider>(context).roomData['isJoin']
            ? const WaitingPage()
            : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Scoreboard(),
                    const Board(),
                    Text(Provider.of<RoomDataProvider>(context).roomData['turn']['nickname'])
                  ],
                ),
              ));
  }
}
