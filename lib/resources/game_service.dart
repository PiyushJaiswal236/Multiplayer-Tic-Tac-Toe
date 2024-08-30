import 'package:flutter/cupertino.dart';
import 'package:multiplayer_tick_tac_toe/providers/room_data_provider.dart';
import 'package:multiplayer_tick_tac_toe/resources/SocketService.dart';
import 'package:provider/provider.dart';

Socketservice _socketservice = Socketservice();

void restartMatch(BuildContext context,Map<String,dynamic> roomData) {
  RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context,listen: false);
  roomDataProvider.updateRoomData(roomData);
}
void restartBoard(BuildContext context){
  RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context,listen: false);
  roomDataProvider.clearBoard();
  roomDataProvider.updateFilledBoxes(0);
}