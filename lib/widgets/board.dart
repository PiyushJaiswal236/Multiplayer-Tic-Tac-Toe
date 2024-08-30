import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/providers/room_data_provider.dart';
import 'package:multiplayer_tick_tac_toe/resources/SocketService.dart';
import 'package:provider/provider.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}


class _BoardState extends State<Board> {
  final Socketservice _socketservice = Socketservice();

  void onTap(int index, RoomDataProvider roomDataProvider) {
    _socketservice.onGridTap(index, roomDataProvider.roomData['_id'],
        roomDataProvider.displayElement);
  }


  @override
  void initState() {
    super.initState();
    _socketservice.tapAckListener(context);
    _socketservice.matchConcludedListener(context);
    _socketservice.replayRequestedListener(context);
    _socketservice.gameRestartListener(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size.height * 0.7, maxWidth: 500),
      child: AbsorbPointer(
        absorbing: roomDataProvider.roomData['turn']['socketId'] != _socketservice.socketClient.id,
        child: GridView.builder(
          itemCount: 9,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => {onTap(index, roomDataProvider)},
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white24)),
                child: Center(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 100),
                    child: Text(
                      roomDataProvider.displayElement[index],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                                blurRadius: 20,
                                color: roomDataProvider.displayElement[index] == 'O'
                                    ? Colors.blue : Colors.red),
                          ]),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
