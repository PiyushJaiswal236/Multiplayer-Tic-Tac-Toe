import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiplayer_tick_tac_toe/pages/game_page.dart';
import 'package:multiplayer_tick_tac_toe/providers/room_data_provider.dart';
import 'package:multiplayer_tick_tac_toe/resources/SocketService.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uni_links2/uni_links.dart';

Socketservice _socketservice = Socketservice();

void showSnackBar(BuildContext context, String data) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(data),
  ));
}

void showGameDialogue(BuildContext context, String text) {
  showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
          content: const SizedBox(
            height: 1,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _socketservice.requestReplay(context,
                      Provider.of<RoomDataProvider>(context,listen: false).roomData['_id']);
                },
                child: const Text('Play Again')),
          ],
        );
      });
}

Timer? startPingTimer(BuildContext context) {
  Timer? pingTimer;
  pingTimer = Timer.periodic(const Duration(seconds:  2), (timer) {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    _socketservice.ping(startTime);
  });

  return pingTimer;
}

void shareAppLink(String roomId) {
  Share.share('Join my game room: https://yourdomain.com/room?id=$roomId');
}

StreamSubscription? setUriLinkStream(BuildContext context){
  Socketservice socketservice = Socketservice();
  return uriLinkStream.listen((Uri? uri){
    if(uri!=null){
      final String? _roomId = uri.queryParameters['id'];
      print('Received deep link: ${uri.toString()}');

      print('Room ID: $_roomId');
      socketservice.roomJoinedListener(context);
      socketservice.joinRoom("GuestInvitee", _roomId!);

      Navigator.pushNamed(context, GamePage.routeName);
    }
  });

}

